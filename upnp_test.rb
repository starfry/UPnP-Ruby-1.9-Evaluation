#!/usr/bin/ruby
#
# A very quick and dirty test program for UPnP
# initally based on examples at http://docs.seattlerb.org/UPnP/index.html
#
# (starfry, Apr 9th 2012)

require 'bundler/setup'

require 'UPnP/SSDP'
require 'UPnP/control/device'

resources = UPnP::SSDP.new.search :root
locations = resources.map { |resource| resource.location }
puts locations.join("\n")

locations.each do |location|
  puts "########################################################################"
  puts location

  # Skip my IGD because it causes ruby UPnP to bork
  # (and I'm not interested in the IGD anyways)
  next if location.to_s == "http://10.0.0.138/upnp/IGD.xml" 
  
  device = UPnP::Control::Device.create location

  puts "-----------------"
  puts "Friendly Name:     " + device.friendly_name unless device.friendly_name.nil?
  puts "Manufacturer:      " + device.manufacturer unless device.manufacturer.nil?
  puts "Manufacturer URL: " + device.manufacturer_url.request_uri unless device.manufacturer_url.nil?
  puts "Model Description: " + device.model_description unless device.model_description.nil?
  puts "Model Name:        " + device.model_name unless device.model_name.nil?
  puts "Model Number:      " + device.model_number unless device.model_number.nil?
  puts "Model URL:         " + device.model_url unless device.model_url.nil?
  puts "Name:              " + device.name unless device.name.nil?
  puts "Presentation URL:  " + device.presentation_url unless device.presentation_url.nil?
  puts "Serial Number:     " + device.serial_number unless device.serial_number.nil?
  puts "Type:              " + device.type unless device.type.nil?
  puts "UPC:               " + device.upc unless device.upc.nil?
  puts "URL:               " + device.url.request_uri unless device.url.nil?
  puts "-----------------"
  
  puts "Services:          "
  service_names = device.services.map do |service|
    service.methods(false)
  end
  puts service_names.sort.join("\n")
  
  puts "Sub-Devices:       " 
  sub_device_names = device.sub_devices.map do |sub_device|
    sub_device.methods(false)
  end
  puts sub_device_names.sort.join("\n")
  
  puts "Sub-Services:      "
  sub_service_names = device.sub_services.map do |sub_service|
    sub_service.methods(false)
  end
  puts sub_service_names.sort.join("\n")
  
  puts "-----------"
  device.services.each do |service|
  #  service.actions.each { |action| puts action[0] }
    puts service.control_url
    puts service.driver
    puts service.event_sub_url
    puts service.id
    puts service.scpd_url
    puts service.type
    puts service.url
  end
end
