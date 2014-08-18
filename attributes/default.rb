node.default['drupal']['version'] = 'latest'
node.default['drupal']['install_method'] = 'package'
node.default['drupal']['databases'] = {
  'default/default' => {
    'driver' => 'mysql',
    'database' => 'test',
    'username' => 'foo',
    'password' => 'secret',
    'host' => 'localhost',
    'prefix' => ''
  }
}
