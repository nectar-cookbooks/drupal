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
node.default['drupal']['site_name'] = nil
node.default['drupal']['theme_default'] = nil
node.default['drupal']['anonymous'] = nil
node.default['drupal']['maintenance_theme'] = nil
node.default['drupal']['reverse_proxy'] = false
node.default['drupal']['reverse_proxy_header'] = nil
node.default['drupal']['reverse_proxy_addresses'] = nil
node.default['drupal']['omit_vary_cookie'] = false
node.default['drupal']['css_gzip_conversion'] = true
node.default['drupal']['js_gzip_conversion'] = true
