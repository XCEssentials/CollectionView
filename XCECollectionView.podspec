projName = 'CollectionView'
projSummary = 'UICollectionView wrapped in a container with dedicated (customizable) views for "Empty" and "Failure" states.'
companyPrefix = 'XCE'
companyName = 'XCEssentials'
companyGitHubAccount = 'https://github.com/' + companyName
companyGitHubPage = 'https://' + companyName + '.github.io'

#===

Pod::Spec.new do |s|

  s.name                      = companyPrefix + projName
  s.summary                   = projSummary
  s.version                   = '1.1.6'
  s.homepage                  = companyGitHubPage + '/' + projName

  s.source                    = { :git => companyGitHubAccount + '/' + projName + '.git', :tag => s.version }

  s.requires_arc              = true

  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Maxim Khatskevich' => 'maxim@khatskevi.ch' }

  s.default_subspec           = 'Core'

  # === Platforms - All

  #

  # === Platforms - iOS

  s.ios.deployment_target     = '9.0'

  s.ios.framework             = 'UIKit'

  # === Subspecs - Core

  s.subspec 'Core' do |sub|

    # === All platforms

    #

    # === iOS

    sub.ios.source_files      = 'Sources/Core/**/*.swift'

  end

  # === Subspecs - WithData

  s.subspec 'WithData' do |sub|

    # === All platforms

    #

    # === iOS

    sub.ios.source_files      = 'Sources/WithData/**/*.swift'

    sub.ios.dependency          s.name + '/Core'

    sub.ios.dependency          'XCECollectionData', '~> 1.1.0'

  end

end
