#@example create new role
#  ~createrole <rolecolour in decimal form> <rolename>
#@example change role colour
#  ~changerolecolour <rolecolour in decimal form> <rolename>
#@example change role name
#  ~changerolename <new rolename> <rolename>
#@example delete a role
#  ~deleterole <rolename>
#@example assign a role
#  ~assignrole @<userid> <rolename>
#@example remove a role
#  ~removerole @<userid> <rolename>
module Roles
  extend Discordrb::Commands::CommandContainer

  command(:createrole, min_args: 2, required_permissions: [:manage_roles], permission_message: 'It seems you do not have permission to manage roles.') do |event, *rolename|
   	rolecolour = rolename[0].to_i
	rolename = rolename[1..-1].join(' ')
    begin
      role = event.server.create_role
      role.name = rolename
	  role.colour = Discordrb::ColourRGB.new(rolecolour)
      event.respond "`#{rolename}` was successfully created."
    rescue Discordrb::Errors::NoPermission
      event.respond "I'm sorry, I do not have permission to 'manage roles'."
    end
  end
  
  command(:changerolecolour, min_args: 2, required_permissions: [:manage_roles], permission_message: 'It seems you do not have permission to manage roles.') do |event, *rolename|
   	rolecolour = rolename[0].to_i
	rolename = rolename[1..-1].join(' ')
    begin
      therole = event.server.roles.find { |role| role.name == rolename }
	  therole.colour = Discordrb::ColourRGB.new(rolecolour)
      event.respond "`#{therole.name}` was successfully changed."
    rescue Discordrb::Errors::NoPermission
      event.respond "I'm sorry, I do not have permission to 'manage roles'."
    end
  end
  
  command(:changerolename, min_args: 2, required_permissions: [:manage_roles], permission_message: 'It seems you do not have permission to manage roles.') do |event, *rolename|
   	newname = rolename[0]
	rolename = rolename[1..-1].join(' ')
    begin
      therole = event.server.roles.find { |role| role.name == rolename }
	  therole.name = newname
      event.respond "`#{rolename}` was successfully changed to `#{therole.name}`."
    rescue Discordrb::Errors::NoPermission
      event.respond "I'm sorry, I do not have permission to 'manage roles'."
    end
  end

  command(:deleterole, max_args: 1, required_permissions: [:manage_roles], permission_message: 'It seems you do not have permission to manage roles.') do |event, *rolename|
    rolename = rolename.join(' ')
    begin
      therole = event.server.roles.find { |role| role.name == rolename }
      therole.delete
      event.respond "`#{rolename}` was successfully deleted."
    rescue Discordrb::Errors::NoPermission
      event.respond "I'm sorry, I do not have permission to 'manage roles'."
    end
  end

  command(:assignrole, min_args: 2, required_permissions: [:manage_roles], permission_message: 'It seems you do not have permission to manage roles.') do |event, mention, *rolename|
    id = mention.scan(/@([^"]*)>/).join.to_i
	user = event.server.member(id)
    rolename = rolename.join(' ')
    begin
      therole = event.server.roles.find { |role| role.name == rolename }
	  if !therole.to_s.empty?
		user.add_role(therole)
		event.respond "#{user.distinct} was given the role `#{rolename}`."
	  else 
        event.respond "Excuse me, `#{rolename}` seems not to exist."
	  end
    rescue Discordrb::Errors::NoPermission
      event.respond "I'm sorry, I do not have permission to 'manage roles'."
    end
  end

  command(:removerole, min_args: 2, required_permissions: [:manage_roles], permission_message: 'It seems you do not have permission to manage roles.') do |event, mention, *rolename|
    id = mention.scan(/@([^"]*)>/).join.to_i
    user = event.server.member(id)
    rolename = rolename.join(' ')
    begin
      therole = event.server.roles.find { |role| role.name == rolename }
	  if !therole.to_s.empty?
		user.remove_role(therole)
        event.respond "#{user.distinct} lost the role `#{rolename}`."
	  else 
        event.respond "Excuse me, `#{rolename}` seems not to exist."
	  end
    rescue Discordrb::Errors::NoPermission
      event.respond "I'm sorry, I do not have permission to 'manage roles'."
    end
  end
end