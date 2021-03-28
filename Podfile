# Uncomment the next line to define a global platform for your project
 platform :ios, '13.3.1'

target 'CheckNow' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks  :modular_headers => true use_frameworks!
  use_modular_headers!

  # Pods for CheckNow
  pod 'SQLite.swift', :git => 'https://github.com/stephencelis/SQLite.swift', :branch => 'master'
  #pod 'SQLite.swift', '~> 0.11.5' because of syntax error, had to point to master
  #https://github.com/stephencelis/SQLite.swift/issues/895
  pod 'Eureka', :git => 'https://github.com/xmartlabs/Eureka.git'
  
  
  target 'CheckNowTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
