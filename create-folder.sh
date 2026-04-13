#!/bin/bash

# ==========================================
# SECTION 1: Operating System Level Configuration
# ==========================================
# Manual
mkdir -p manual-audit/1_operating_system_level_configuration/1.1_place_databases_on_non_system_partitions
mkdir -p manual-audit/1_operating_system_level_configuration/1.7_ensure_mysql_is_run_under_a_sandbox_environment
# Automated
mkdir -p automation-audit/1_operating_system_level_configuration/1.2_use_dedicated_least_privileged_account_for_mysql_daemon
mkdir -p automation-audit/1_operating_system_level_configuration/1.3_disable_mysql_command_history
mkdir -p automation-audit/1_operating_system_level_configuration/1.4_verify_that_the_mysql_pwd_environment_variable_is_not_in_use
mkdir -p automation-audit/1_operating_system_level_configuration/1.5_ensure_interactive_login_is_disabled
mkdir -p automation-audit/1_operating_system_level_configuration/1.6_verify_that_mysql_pwd_is_not_set_in_users_profiles

# ==========================================
# SECTION 2: Installation and Planning
# ==========================================
# Manual
mkdir -p manual-audit/2_installation_and_planning/2.1.1_backup_policy_in_place
mkdir -p manual-audit/2_installation_and_planning/2.1.2_verify_backups_are_good
mkdir -p manual-audit/2_installation_and_planning/2.1.3_secure_backup_credentials
mkdir -p manual-audit/2_installation_and_planning/2.1.5_disaster_recovery_plan
mkdir -p manual-audit/2_installation_and_planning/2.1.6_backup_of_configuration_and_related_files
mkdir -p manual-audit/2_installation_and_planning/2.3_dedicate_the_machine_running_mysql
mkdir -p manual-audit/2_installation_and_planning/2.4_do_not_specify_passwords_in_the_command_line
mkdir -p manual-audit/2_installation_and_planning/2.5_do_not_reuse_usernames
mkdir -p manual-audit/2_installation_and_planning/2.6_ensure_non_default_unique_cryptographic_material_is_in_use
mkdir -p manual-audit/2_installation_and_planning/2.10_use_dual_passwords_to_enable_higher_frequency_password_rotation
mkdir -p manual-audit/2_installation_and_planning/2.11_lock_out_accounts_if_not_currently_in_use
mkdir -p manual-audit/2_installation_and_planning/2.13_ensure_socket_peer_credential_authentication_is_used_appropriately
mkdir -p manual-audit/2_installation_and_planning/2.19_ensure_fips_140_2_openssl_cryptography_is_used
# Automated
mkdir -p automation-audit/2_installation_and_planning/2.1.4_point_in_time_recovery
mkdir -p automation-audit/2_installation_and_planning/2.2.1_ensure_binary_and_relay_logs_are_encrypted
mkdir -p automation-audit/2_installation_and_planning/2.7_ensure_password_lifetime_is_less_than_or_equal_to_365
mkdir -p automation-audit/2_installation_and_planning/2.8_ensure_password_resets_require_strong_passwords
mkdir -p automation-audit/2_installation_and_planning/2.9_require_current_password_for_password_reset
mkdir -p automation-audit/2_installation_and_planning/2.12_ensure_aes_encryption_mode_is_configured_correctly
mkdir -p automation-audit/2_installation_and_planning/2.14_ensure_mysql_is_bound_to_an_ip_address
mkdir -p automation-audit/2_installation_and_planning/2.15_limit_accepted_tls_versions
mkdir -p automation-audit/2_installation_and_planning/2.16_require_client_side_certificates
mkdir -p automation-audit/2_installation_and_planning/2.17_ensure_only_approved_ciphers_are_used
mkdir -p automation-audit/2_installation_and_planning/2.18_implement_connection_delays_to_limit_failed_login_attempts

# ==========================================
# SECTION 3: File Permissions (All Automated)
# ==========================================
mkdir -p automation-audit/3_file_permissions/3.1_ensure_datadir_has_appropriate_permissions
mkdir -p automation-audit/3_file_permissions/3.2_ensure_log_bin_basename_files_have_appropriate_permissions
mkdir -p automation-audit/3_file_permissions/3.3_ensure_log_error_has_appropriate_permissions
mkdir -p automation-audit/3_file_permissions/3.4_ensure_slow_query_log_has_appropriate_permissions
mkdir -p automation-audit/3_file_permissions/3.5_ensure_relay_log_basename_files_have_appropriate_permissions
mkdir -p automation-audit/3_file_permissions/3.6_ensure_general_log_file_has_appropriate_permissions
mkdir -p automation-audit/3_file_permissions/3.7_ensure_ssl_key_files_have_appropriate_permissions
mkdir -p automation-audit/3_file_permissions/3.8_ensure_plugin_directory_has_appropriate_permissions

# ==========================================
# SECTION 4: General
# ==========================================
# Manual
mkdir -p manual-audit/4_general/4.1_ensure_the_latest_security_patches_are_applied
# Automated
mkdir -p automation-audit/4_general/4.2_ensure_example_or_test_databases_are_not_installed
mkdir -p automation-audit/4_general/4.3_ensure_allow_suspicious_udfs_is_set_to_off
mkdir -p automation-audit/4_general/4.4_harden_usage_for_local_infile
mkdir -p automation-audit/4_general/4.5_ensure_mysqld_is_not_started_with_skip_grant_tables
mkdir -p automation-audit/4_general/4.6_ensure_symbolic_links_are_disabled
mkdir -p automation-audit/4_general/4.7_ensure_secure_file_priv_is_configured_correctly
mkdir -p automation-audit/4_general/4.8_ensure_sql_mode_contains_strict_all_tables
mkdir -p automation-audit/4_general/4.9_use_mysql_tde_for_at_rest_data_encryption

# ==========================================
# SECTION 5: MySQL Permissions (All Manual)
# ==========================================
mkdir -p manual-audit/5_mysql_permissions/5.1_ensure_only_administrative_users_have_full_database_access
mkdir -p manual-audit/5_mysql_permissions/5.2_ensure_file_is_not_granted_to_non_administrative_users
mkdir -p manual-audit/5_mysql_permissions/5.3_ensure_process_is_not_granted_to_non_administrative_users
mkdir -p manual-audit/5_mysql_permissions/5.4_ensure_super_is_not_granted_to_non_administrative_users
mkdir -p manual-audit/5_mysql_permissions/5.5_ensure_shutdown_is_not_granted_to_non_administrative_users
mkdir -p manual-audit/5_mysql_permissions/5.6_ensure_create_user_is_not_granted_to_non_administrative_users
mkdir -p manual-audit/5_mysql_permissions/5.7_ensure_grant_option_is_not_granted_to_non_administrative_users
mkdir -p manual-audit/5_mysql_permissions/5.8_ensure_replication_slave_is_not_granted_to_non_administrative_users
mkdir -p manual-audit/5_mysql_permissions/5.9_ensure_dml_ddl_grants_are_limited_to_specific_databases_and_users
mkdir -p manual-audit/5_mysql_permissions/5.10_securely_define_stored_procedures_and_functions
mkdir -p manual-audit/5_mysql_permissions/5.11_ensure_proper_use_of_set_any_definer
mkdir -p manual-audit/5_mysql_permissions/5.12_ensure_proper_use_of_allow_nonexistent_definer

# ==========================================
# SECTION 6: Auditing and Logging (All Automated)
# ==========================================
mkdir -p automation-audit/6_auditing_and_logging/6.1_ensure_log_error_is_configured_correctly
mkdir -p automation-audit/6_auditing_and_logging/6.2_ensure_log_files_are_stored_on_a_non_system_partition
mkdir -p automation-audit/6_auditing_and_logging/6.3_ensure_log_error_verbosity_is_set_to_2
mkdir -p automation-audit/6_auditing_and_logging/6.4_ensure_log_raw_is_set_to_off

# ==========================================
# SECTION 7: Authentication (All Automated)
# ==========================================
mkdir -p automation-audit/7_authentication/7.1_ensure_authentication_policy_is_set_to_secure_option
mkdir -p automation-audit/7_authentication/7.2_ensure_passwords_are_not_stored_in_global_configuration
mkdir -p automation-audit/7_authentication/7.3_ensure_passwords_are_set_for_all_mysql_accounts
mkdir -p automation-audit/7_authentication/7.4_set_default_password_lifetime_to_require_yearly_change
mkdir -p automation-audit/7_authentication/7.5_ensure_password_complexity_policies_are_in_place
mkdir -p automation-audit/7_authentication/7.6_ensure_no_users_have_wildcard_hostnames
mkdir -p automation-audit/7_authentication/7.7_ensure_no_anonymous_accounts_exist

# ==========================================
# SECTION 8: Network
# ==========================================
# Manual
mkdir -p manual-audit/8_network/8.3_set_maximum_connection_limits_for_server_and_per_user
# Automated
mkdir -p automation-audit/8_network/8.1_ensure_require_secure_transport_is_set_to_on
mkdir -p automation-audit/8_network/8.2_ensure_ssl_type_is_set_for_all_remote_users

# ==========================================
# SECTION 9: Replication
# ==========================================
# Manual
mkdir -p manual-audit/9_replication/9.1_ensure_replication_traffic_is_secured
# Automated
mkdir -p automation-audit/9_replication/9.2_ensure_source_ssl_verify_server_cert_is_set_to_yes
mkdir -p automation-audit/9_replication/9.3_ensure_super_priv_is_not_set_to_y_for_replication_users

# ==========================================
# SECTION 10: InnoDB Cluster (All Manual)
# ==========================================
mkdir -p manual-audit/10_innodb_cluster/10.1_ensure_all_group_replication_traffic_is_secured
mkdir -p manual-audit/10_innodb_cluster/10.2_allowlist_approved_servers_belonging_to_cluster

echo "Directory structure created successfully!"
