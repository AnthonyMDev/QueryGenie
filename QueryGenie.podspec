Pod::Spec.new do |s|
    s.name              = 'QueryGenie'
    s.version           = '1.1.0'
    s.summary           = 'A lightweight framework for creating type-safe queries. With out-of-the-box support for CoreData and Realm.'

    s.homepage          = 'https://github.com/AnthonyMDev/QueryGenie'
    s.license           = { :type => 'MIT', :file => 'LICENSE' }
    s.author            = { 'Anthony Miller' => 'AnthonyMDev@gmail.com' }
    s.social_media_url  = 'https://twitter.com/AnthonyMDev'
    
    s.source            = { :git => 'https://github.com/AnthonyMDev/QueryGenie.git', :tag => s.version.to_s }
    s.requires_arc      = true
    
    s.ios.deployment_target     = '8.0'
    s.osx.deployment_target     = '10.10'
    s.watchos.deployment_target = '2.0'
    s.tvos.deployment_target    = '9.0'
    
    s.default_subspec   = 'Core'
    
    s.subspec 'Core' do |ss|
        ss.source_files = 'QueryGenie/*.swift'
    end
    
    s.subspec 'Realm' do |ss|
        ss.source_files = 'QueryGenie/Realm/*.swift'
        
        ss.dependency 'QueryGenie/Core'
        
        ss.dependency 'RealmSwift', '~> 3.0'
    end    

    s.subspec 'CoreData' do |ss|
        ss.source_files = 'QueryGenie/CoreData/*.swift'
        
        ss.dependency 'QueryGenie/Core'
        
        ss.framework = 'CoreData'
    end
    
end
