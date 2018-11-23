class InfraVisor < ActiveRecord::Base
  self.establish_connection(
   :adapter	=> 'sqlserver',
   :database	=> 'INFRAVISOR',
   :host 	=> '192.168.1.61',
   :port	=> '1433',
   :username	=> {{ user }},
   :password	=> {{ pass }}'
  )
end
