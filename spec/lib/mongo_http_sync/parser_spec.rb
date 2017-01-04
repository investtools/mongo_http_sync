require 'mongo_http_sync/parser'
require 'json'

describe MongoHTTPSync::Parser do
  let(:json) { content.to_json }
  let(:io) { StringIO.new(json) }
  describe '.parse' do
    let(:content) { [ { name: 'Andre' } ] }
    it 'yields for each item' do
      expect { |b| MongoHTTPSync::Parser.parse(io, &b) }.to yield_with_args(*content)
    end
    it 'returns the number of yielded documents' do
      expect(MongoHTTPSync::Parser.parse(io) {}).to eq 1
    end
    context 'when there is a hash inside a hash' do
      let(:content) { [ { name: 'Andre', location: { country: 'Brazil' } } ] }
      it 'does not yield for inner hash' do
        expect { |b| MongoHTTPSync::Parser.parse(io, &b) }.to yield_with_args(*content)
      end
    end
    context 'in order to handle large content' do
      let(:mock_io_class) do
        Class.new do
          def initialize(string)
            @underlying_io = StringIO.new(string)
          end
          def readpartial(maxlen, outbuf=nil)
            outbuf ? @underlying_io.readpartial(3, outbuf) : @underlying_io.readpartial(3)
          end
          def read(length, outbuf=nil)
            throw 'this method should not be used!'
          end
        end
      end
      let(:io) { mock_io_class.new(json) }
      it 'uses IO#readpartial' do
        expect { |b| MongoHTTPSync::Parser.parse(io, &b) }.to yield_with_args(name: 'Andre')
      end
    end
  end
end
