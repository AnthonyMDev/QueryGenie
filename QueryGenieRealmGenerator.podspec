Pod::Spec.new do |s|
    s.name              = "QueryGenieRealmGenerator"
    s.version           = "1.0.0"
    s.summary           = "A generator for creating Attribute extensions for your Realm objects to use with QueryGenie."

    s.homepage          = "https://github.com/AnthonyMDev/QueryGenie"
    s.license           = { :type => 'MIT', :file => 'LICENSE' }
    s.author            = { "Anthony Miller" => "AnthonyMDev@gmail.com" }
    s.social_media_url  = 'https://twitter.com/AnthonyMDev'
    
    s.source            = { :git => "https://github.com/AnthonyMDev/QueryGenie.git", :tag => s.version.to_s }
    s.requires_arc      = true
    
    s.ios.deployment_target     = '8.0'
    s.osx.deployment_target     = '10.10'
    s.watchos.deployment_target = '2.0'
    s.tvos.deployment_target    = '9.0'

    s.source_files = 'QueryGenie/RealmGenerator/*.swift'
        
    s.dependency 'Realm', '3.0.0-beta'

end
