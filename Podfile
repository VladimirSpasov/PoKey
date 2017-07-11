# Uncomment the next line to define a global platform for your project
#platform :ios, '9.0'

def common_pods
  pod 'PokemonKit', :path => './'
  pod 'AlamofireImage'
end

target 'PoKey' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  common_pods
  pod 'expanding-collection', '~> 1.0.3'
  pod 'Charts'

  target 'PoKeyTests' do
    inherit! :search_paths

    # Pods for testing
  end

  target 'PoKeyUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'PoKeyKeyboard' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  common_pods
  pod 'SnapKit'
end
