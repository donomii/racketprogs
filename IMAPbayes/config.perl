{
    server => '',
    user   => '',
    pass   => '',
    ssl    => 1,                              # (use SSL? default no) 
    ssl_verify_peer => 1,                     # (use ca to verify server, default yes)
    #ssl_ca_file => '/etc/ssl/certs/certa.pm', # (CA file used for verify server) or
    ssl_ca_path => '/etc/ssl/certs/',         # (CA path used for SSL)
    port   => 993                             # (but defaults are sane)
}
