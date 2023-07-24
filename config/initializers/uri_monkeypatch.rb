# Monkeypatch to extend life of Dragongly for Ruby 3
# TODO: remove after removing Dragonfly

require 'uri'

module URI
  def self.escape(*args)
    URI.encode_www_form_component(*args)
  end
end