maintainer       "IT Thugs"
maintainer_email "support@itthugs.com"
license          "Apache 2.0"
description      "Installs/Configures Base System"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

%w{ ubuntu debian }.each do |os|
  supports os
end
