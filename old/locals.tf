locals {

  ########################
  # ロール
  ########################

  # 設定ファイルをロード
  access_roles_yml = yamldecode(
    file("${path.root}/config/functional_and_access_roles/access_roles.yml")
  )

  functional_roles_yml = yamldecode(
    file("${path.root}/config/functional_and_access_roles/functional_roles.yml")
  )

  access_roles_to_functional_roles_yml = yamldecode(
    file("${path.root}/config/functional_and_access_roles/access_roles_to_functional_roles.yml")
  )

  # Access role(database role以外) のリスト
  access_roles = local.access_roles_yml.access_roles

  # Access role(database roleのみ) のリスト
  access_db_roles = local.access_roles_yml.access_db_roles

  # grant ... database to Access role のリスト
  grant_database_to_access_db_role = flatten([
    for grant in local.access_roles_yml["grant_database_to_access_db_roles"] : [
      for role in grant.roles : {
        type        = grant.type
        parameter   = grant.parameter
        access_role = role
        grant_name  = grant.name
      }
    ]
  ])

  # grant ... schema to Access role のリスト
  grant_schema_to_access_db_role = flatten([
    for grant in local.access_roles_yml["grant_schema_to_access_db_roles"] : [
      for role in grant.roles : {
        type        = grant.type
        parameter   = grant.parameter
        access_role = role
        grant_name  = grant.name
      }
    ]
  ])

  # grant ... table to Access role のリスト
  grant_table_to_access_db_role = flatten([
    for grant in local.access_roles_yml["grant_table_to_access_db_roles"] : [
      for role in grant.roles : {
        type        = grant.type
        parameter   = grant.parameter
        access_role = role
        grant_name  = grant.name
      }
    ]
  ])

  # grant ... warehouse to Access role のリスト
  grant_warehouse_to_access_role = flatten([
    for grant in local.access_roles_yml["grant_warehouse_to_access_roles"] : [
      for role in grant.roles : {
        type        = grant.type
        parameter   = grant.parameter
        access_role = role
        grant_name  = grant.name
      }
    ]
  ])

  # Functional roleのリスト
  functional_roles = local.functional_roles_yml.functional_roles

  # grant Functional role to ユーザーのリスト
  grant_functional_roles_to_user = flatten([
    for grant in local.functional_roles_yml["grant_functional_roles_to_user"] : [
      for user in grant.users : {
        functional_role = grant.role_name
        user_name       = user
      }
    ]
  ])

  # grant Access role(database role以外) to Functional role のリスト
  grant_access_role_to_functional_role = flatten([
    for grant in local.access_roles_to_functional_roles_yml["grant_access_roles_to_functional_roles"] : [
      for role in grant.functional_roles : {
        access_role     = grant.access_role
        functional_role = role
      }
    ]
  ])

  # grant Access role(database roleのみ) to Functional role のリスト
  grant_access_db_role_to_functional_role = flatten([
    for grant in local.access_roles_to_functional_roles_yml["grant_access_db_roles_to_functional_roles"] : [
      for role in grant.functional_roles : {
        access_role     = grant.access_role
        database        = grant.database
        functional_role = role
      }
    ]
  ])

}