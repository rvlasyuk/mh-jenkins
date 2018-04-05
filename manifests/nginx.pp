include ::nginx

nginx::resource::upstream { 'spring':
  members => [
    '192.168.20.5:8080',
    '192.168.20.6:8080',
  ],
}

nginx::resource::server { 'localhost':
    proxy => 'http://spring',
    listen_port => 8085,
}
