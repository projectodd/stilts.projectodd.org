
require 'documentation'

Awestruct::Extensions::Pipeline.new do
  # extension Awestruct::Extensions::Posts.new( '/news' ) 
  extension Documentation.new
  extension Awestruct::Extensions::Indexifier.new
end

