Rails.application.routes.draw do
  root 'sessions#new'

  match '/infravisor',            to: 'infra_visor#index',     via: 'get'
  match '/infravisor/download',   to: 'infra_visor#download',  via: 'get'

  match '/voicemessages',         to: 'voice_message#index',   via: 'get'
  match '/voicemessages/download',to: 'voice_message#download',via: 'get'

  match '/callforwarder',         to: 'call_forwarder#index',  via: 'get'
  match '/callforwarder/update',  to: 'call_forwarder#update', via: 'post'

  match '/signin',                to: 'sessions#new',          via: 'get'
  match '/signin',                to: 'sessions#create',       via: 'post'
  match '/signout',               to: 'sessions#destroy',      via: 'delete'
  match '/users',                 to: 'sessions#users',        via: 'get'
  match '/users',                 to: 'sessions#update_users', via: 'post'
  match '/users',                 to: 'sessions#delete_users', via: 'delete'
  match '/phones',                to: 'sessions#phones',       via: 'get'
  match '/phones',                to: 'sessions#update_phones',via: 'post'
  match '/phones',                to: 'sessions#delete_phones',via: 'delete'
end
