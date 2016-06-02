module OrderDecorator 
  def self.extended(mod)
    mod.class.send(:alias_method, :plain_id, :id)
  end
 
  def id
    "%07d" % plain_id
  end
end