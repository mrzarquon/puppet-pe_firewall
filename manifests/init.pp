class pe_firewall {
  case $::osfamily {
    default: { }
    'RedHat', 'Debian': {
      $persist_firewall_command = $::osfamily ? {
        'RedHat' => '/sbin/iptables-save > /etc/sysconfig/iptables',
        'Debian' => '/sbin/iptables-save > /etc/iptables/rules.v4',
      }
      exec { 'persist-firewall':
        command     => $persist_firewall_command,
        refreshonly => true,
      }
      Firewall {
        notify => Exec['persist-firewall'],
        chain  => 'INPUT',
        proto  => 'tcp',
        action => 'accept',
      }
      Firewallchain {
        notify  => Exec['persist-firewall'],
      }
      resources { "firewall":
        purge => true
      }
      firewall { '110 puppetmaster allow all':
        dport  => '8140',
      }
      firewall { '110 dashboard allow all':
        dport  => '443',
      }
      firewall { '110 mcollective allow all':
        dport  => '61613'
      }
    }
  }
}
