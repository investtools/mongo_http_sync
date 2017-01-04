require 'webmock/rspec'
require 'mongo'

RSpec.shared_examples 'an importer' do |importer, collection_name|
  let(:people) { $client[collection_name] }
  describe '#import' do
    before do
      stub_request(:get, %r{^http://www.example.com/clients.*$}).
        to_return(body: docs_from_http.to_json)
    end
    let(:url) { 'http://www.example.com/clients' }
    let(:andre) { { id: '1a', name: 'Andre', updated_at: Time.parse('2015-05-05 10:10:10.123 UTC') } }
    let(:docs_from_http) { [ andre ] }
    it 'imports json to mongodb' do
      importer.import('http://www.example.com/clients')
      expect(people.count).to eq 1
    end
    it 'uses id field as _id' do
      importer.import('http://www.example.com/clients')
      expect(people.find(_id: '1a').count).to eq 1
    end
    context 'when there are already documents persisted' do
      before do
        people.insert_one(_id: '10', name: 'Fabio', updated_at: Time.parse('2015-05-05 10:10:10.123 UTC'))
      end
      it 'it fetches only the newer documents' do
        importer.import('http://www.example.com/clients')
        expect(a_request(:get, "http://www.example.com/clients?updated_since=#{URI.encode('2015-05-05 10:10:10.123 UTC')}")).
          to have_been_made.once
      end
    end
    context 'when an updated document is fetched' do
      before do
        people.insert_one(_id: '1a', name: 'Andrz', last_name: 'Kelmanson', updated_at: Time.parse('2015-05-05 08:10:10 UTC'))
      end
      it 'updates the document on mongodb' do
        importer.import('http://www.example.com/clients')
        expect(people.find.first['name']).to eq 'Andre'
      end
    end
    context 'when an entity is defined' do
      let(:entity_class) do
        Class.new(MongoHTTPSync::Entity) do
          expose('name') { |person| person[:name].upcase }
        end
      end
      it 'applies it before persisting' do
        importer.import('http://www.example.com/clients', entity: entity_class)
        expect(people.find.first).to eq(
          '_id' => '1a',
          'name' => 'ANDRE',
          'updated_at' => Time.parse('2015-05-05 10:10:10.123 UTC')
        )
      end
    end
  end
end
