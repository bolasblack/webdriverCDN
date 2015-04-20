require 'net/http'
require 'fileutils'
require 'json'

class String
  def short
    self.split('.')[0..1].join '.'
  end
end

download_path = './downloaded'

urls = {
  selenium: -> (version) {
    ["https://selenium-release.storage.googleapis.com/#{version.short}/selenium-server-standalone-#{version}.jar"]
  },
  chromedriver: -> (version) {
    prefix = "https://chromedriver.storage.googleapis.com/#{version.short}/chromedriver_"
    urls = []
    urls << "#{prefix}mac32.zip"
    urls << "#{prefix}linux64.zip"
    urls << "#{prefix}linux32.zip"
    urls << "#{prefix}win32.zip"
    urls
  },
  iedriver: -> (version) {
    prefix = "https://selenium-release.storage.googleapis.com/#{version.short}/IEDriverServer"
    urls = []
    urls << "#{prefix}_x64_#{version}.zip"
    urls << "#{prefix}_Win32_#{version}.zip"
    urls
  }
}

resp = Net::HTTP.get_response URI 'https://raw.githubusercontent.com/angular/protractor/master/config.json'
fail 'Request version data failed' unless 200 <= resp.code.to_i || resp.code.to_i < 300

versions = JSON.parse(resp.body)['webdriverVersions']
urls.map do |name, fn|
  current_version = versions[name.to_s]
  path = File.join(download_path, current_version)
  fn.call(current_version).map { |url| {url: url, path: path} }
end.compact.flatten.each do |info|
  FileUtils.mkdir_p info[:path]
  filename = File.join info[:path], File.basename(URI(info[:url]).path)
  next if File.exist? filename
  `wget -O #{filename} #{info[:url]}`
end
