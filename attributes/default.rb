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
node.default['drupal']['update_free_access'] = false
node.default['drupal']['hash_salt'] = "''"    # a PHP expression is required
node.default['drupal']['session_cookie_lifetime'] = 2000000
node.default['drupal']['pcre_backtrack_limit'] = nil  # e.g. 200000
node.default['drupal']['pcre_recursion_limit'] = nil  # e.g. 200000
node.default['drupal']['cookie_domain'] = nil  # e.g. 'example.com'
