def log(str)
  puts str if debug?
end

def run_cmd(str)
  log(str)

  system(str)
end
