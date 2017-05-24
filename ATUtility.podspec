Pod::Spec.new do |s|
  s.name             = 'ATUtility'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ATUtility.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/csutanyu/ATUtility.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'larrytin' => 'csutanyu@126.com' }
  s.source           = { :git => 'https://github.com/csutanyu/ATUtility.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.default_subspec = 'Core'

  s.subspec 'Core' do |sp|
    sp.dependency 'SDWebImage/GIF', '~>4.0'
    sp.source_files = 'ATUtility/ATUtility/ATUtility/ATUtility/**/*'
    sp.resources = ['QQLBroadcast/Assets/**/*']
    sp.prefix_header_file = 'Example/Legacy/Sources/Supporting Files/QQLiveBroadcast-prefix.pch'
  end
end
