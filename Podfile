source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

abstract_target 'AllPods' do
    pod 'RealmSwift', '~> 2.4'
    
    target 'QueryGenie_iOS' do
        platform :ios, '8.0'
    end
    
    target 'QueryGenie_OSX' do
        platform :osx, '10.10'
    end
    

    abstract_target 'Tests' do
        
        pod 'Nimble', '~> 5.1'

        target 'QueryGenieTests_iOS' do
            platform :ios, '8.0'
        end
    
        target 'QueryGenieTests_OSX' do
            platform :osx, '10.10'
        end

    end
end
