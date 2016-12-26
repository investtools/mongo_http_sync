require 'oj'

module MongoHTTPSync
  class Parser
    def self.parse(io, &block)
      handler = Handler.new(block)
      Oj.sc_parse(handler, ReadpartialWorkaround.new(io))
      handler.ndocs
    end
    class Handler < ::Oj::ScHandler
      attr_reader :ndocs
      def initialize(block)
        @block = block
        @level = 0
        @ndocs = 0
      end

      def hash_start
        @hash = {}
        @root_hash = @hash if @level.zero?
        @level += 1
        @hash
      end

      def hash_end
        @level -= 1
        if @level.zero?
          @block.call @root_hash if @level.zero?
          @ndocs += 1
        end
      end

      def hash_set(h,k,v)
        h[k] = v
      end

      def array_start
        []
      end

      def array_append(a,v)
        a << v
      end

      def error(message, line, column)
        throw "#{message} (line: #{line}, column: #{column})"
      end
    end
    class ReadpartialWorkaround
      def initialize(target)
        @target = target
      end
      def readpartial(maxlen)
        if @buffer and @buffer.length > 0
          buff = @buffer[0..maxlen-1]
          @buffer = @buffer[maxlen..-1]
          return buff
        end
        r = @target.readpartial(maxlen)
        if r.dup.bytesize > maxlen
          @buffer = r[maxlen..-1]
          r = r[0..maxlen-1]
        end
        r
      end
    end
  end
end
