#!/usr/bin/env ruby

class SuperConfig2
  def registry
    @@registry
  end

  class << self
    def env(key)
      key_s = key.to_sym

      lookup_default = @keys[key_s]

      override_found = ENV[key_s.to_s]

      if lookup_default.is_a?(Proc)
        lookup_default.call(override_found)
      else
        override_found || lookup_default
      end
    end

    def force(overrides)
      existing = {}
      overrides.each { |k,v|
        existing[k.to_sym] = ENV[k.to_s]
        raise "only string values allowed" unless v.is_a?(String)
        ENV[k.to_s] = v
      }

      yield

      existing.each { |k,v|
        ENV[k.to_s] = v
      }
    end

    def s(*defaults)
      Proc.new { |override|
        if override
          Array(override.split(":")).join(" ")
        else
          defaults.map(&:to_s).join(" ")
        end
      }
    end

    def i(default)
      Proc.new { |override|
        if override
          override.to_i
        else
          default.to_i
        end
      }
    end

    def bool(default = false)
      Proc.new { |override|
        if override
          (override.to_s == "true") ? true :
            ((override.to_s == "false") ? false : !!default)
        else
          !!default
        end
      }
    end

    def url(default)
      Proc.new { |override|
        URI.parse(override || default)
      }
    end

    def attr_reader(*args)
      @@registry ||= {}
      @@registry[args.first.to_sym] = args.last

      super(args.first)

      define_method(args.first.to_s) do
        args.last.call(ENV[args.first.to_s])
      end
    end
  end
end

#TODO:
#
# misc updated functionality desired below
#
#   k8sserver
#    FOO_SERVICE_HOST/PORT ... whatta about USER/PASS USERNAME/PASSWORD ?
#   mysql2 client helper
#     {"username"=>"root", "password"=>"password", "host"=>"127.0.0.1", "port"=>3306, "encoding"=>"utf8mb4", "collation"=>"utf8mb4_unicode_ci", "strict"=>true, "reconnect"=>true, "pool"=>1, "timeout"=>1, "checkout_timeout"=>1}
