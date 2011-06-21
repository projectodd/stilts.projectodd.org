
class Documentation

  
  def initialize(enabled=true)
    @enabled = enabled
  end

  def execute(site)
    return unless @enabled

    javadocs_path = File.join( site.output_dir, 'javadocs' )

    if ( ! File.exist? javadocs_path ) 
      FileUtils.cp_r '../stilts/target/site/apidocs', javadocs_path
    end
  end
end
