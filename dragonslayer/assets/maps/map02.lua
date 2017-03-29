return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.14.2",
  orientation = "orthogonal",
  renderorder = "right-up",
  width = 30,
  height = 30,
  tilewidth = 32,
  tileheight = 32,
  nextobjectid = 5,
  properties = {},
  tilesets = {
    {
      name = "Tile",
      firstgid = 1,
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "../../../sti_test/assets/images/tiles/Tile.png",
      imagewidth = 224,
      imageheight = 576,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 126,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 30,
      height = 30,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "eJztzcEJAAAIAzFx/6FdQUF8SAL9FS4CAIAPsjHd+27nvzVd3ekKnO4Bew=="
    },
    {
      type = "objectgroup",
      name = "Shapes",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {
        ["collidable"] = true
      },
      objects = {
        {
          id = 2,
          name = "",
          type = "",
          shape = "polyline",
          x = 384,
          y = 960,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polyline = {
            { x = 0, y = 0 },
            { x = 0, y = -192 },
            { x = 576, y = -192 }
          },
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "polyline",
          x = 0,
          y = 672,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polyline = {
            { x = 0, y = 0 },
            { x = 288, y = 0 },
            { x = 288, y = 288 }
          },
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 672,
          y = 608,
          width = 128,
          height = 160,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
