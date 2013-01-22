class PureModel
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  def initialize(params = {})
    @params = params || {}
  end

  def persisted?
    false
  end
  def [](key)
    @params[key.to_sym]
  end

  def []=(key, value)
    @params[key.to_sym] = value
  end

  def to_s
    @params.to_s
  end

  def method_missing(name, *args)
    if name.to_s.ends_with?('=')
      @params[name.to_s.chomp('=').to_sym] = *args[0]
    else
      @params[name.to_sym]
    end
  end

  def delete(key)
    @params.delete key.to_sym
  end
end
