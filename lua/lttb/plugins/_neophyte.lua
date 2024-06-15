if true then
  return {}
end

return {
  'tim-harding/neophyte',
  event = 'VeryLazy',
  opts = {
    fonts = {
      {
        name = 'Fira Code',
      },
    },

    font_size = {
      kind = 'width', -- 'width' | 'height'
      size = 18,
    },
  },
}
