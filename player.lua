Player = {
  new = function(id, steamId, name, role, source)
    local self = setmetatable({}, Player)

    self.id = id
    self.source = source
    self.steamId = steamId
    self.role = role
    self.name = name
    self.alive = false

    self.getId = function(self)
      return self.id
    end

    self.isAdmin = function(self)
      return self.role == 'admin' or self.role == 'owner'
    end
    return self
  end
}
