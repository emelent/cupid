return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.14.2",
  orientation = "orthogonal",
  renderorder = "right-up",
  width = 8,
  height = 8,
  tilewidth = 6,
  tileheight = 6,
  nextobjectid = 12,
  properties = {},
  tilesets = {},
  layers = {
    {
      type = "objectgroup",
      name = "Body",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 1,
          name = "default",
          type = "body",
          shape = "rectangle",
          x = 21,
          y = 10,
          width = 6,
          height = 30,
          rotation = 0,
          visible = false,
          properties = {}
        },
        {
          id = 5,
          name = "crouching",
          type = "body",
          shape = "rectangle",
          x = 21,
          y = 12,
          width = 6,
          height = 20,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      name = "Combat",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 10,
          name = "slash",
          type = "attack",
          shape = "rectangle",
          x = 30,
          y = 6,
          width = 17,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "Block",
          type = "defense",
          shape = "rectangle",
          x = 28,
          y = 11,
          width = 5,
          height = 29,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "imagelayer",
      name = "Image Layer 1",
      x = 0,
      y = -488,
      visible = true,
      opacity = 1,
      image = "../images/shadow.png",
      transparentcolor = "#000100",
      properties = {}
    }
  }
}
