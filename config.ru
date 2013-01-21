# This file is used by Rack-based servers to start the application.

#subdir = nil
subdir = "/inoue_dev" 
ENV['RAILS_RELATIVE_URL_ROOT'] = subdir if subdir

require ::File.expand_path('../config/environment',  __FILE__)

if subdir
    map subdir do
        run SampleMobamas::Application
    end
else
    run SampleMobamas::Application
end
