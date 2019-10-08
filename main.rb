# frozen_string_literal: true

# !/usr/bin/env ruby

require 'fileutils'

def source_dir
  @source_dir ||= ARGV[0]
end

def destination_dir
  @destination_dir ||= ARGV[1]
end

def source_dir_abs_path
  @source_dir_abs_path ||= File.join(root_dir, ARGV[0])
end

def dest_dir_abs_path
  @dest_dir_abs_path ||= File.join(root_dir, ARGV[1])
end

def root_dir
  @root_dir ||= Dir.pwd
end

files_moved = 0

# Check if the source directory and destination directories exist from the
# root directory
def arguments_valid?
  if source_dir.nil? || destination_dir.nil?
    raise 'Usage main.rb <source_dir> <destination_path>'
  end

  directory_exists?(source_dir)
  directory_exists?(destination_dir)
end

# Check if a directory exists in the given path where the ruby file is executed
def directory_exists?(directory)
  return if File.directory?(File.join(Dir.pwd, directory))

  raise "#{directory} does not exist in parent directory #{Dir.pwd}. Check the file placement and try again."
end

# Get all the level 1 directories that exist in the directory name provided
# in the params
# Input: Path to a directory
# Output: Array of all sub directories
def scan_sub_dirs_in_path(path)
  puts 'Scanning destination directories'
  Dir.chdir(path)
  sub_dirs = Dir['*'].select { |o| File.directory?(o) }
  Dir.chdir(root_dir)
  sub_dirs
end

# Scan for all files that exist in the given path
# Input: Path to a directory
# Output: Array of files returned
def get_files_in_path(path)
  puts "Scanning for files in directory: #{path}"
  Dir.entries(path).reject { |f| File.directory? f }
end

def gen_regex_for_dir_name(dir_name)
  tokens = dir_name.downcase.split(' ')
  name_token = tokens.join('\\b.*\\b')
  # puts "REGEX Generated #{name_token}"
  Regexp.new("\\b#{name_token}\\b", Regexp::EXTENDED | Regexp::IGNORECASE)
end

def get_matching_files(regex, test_files)
  result_set = []
  test_files.map do |each_file|
    result_set << each_file if each_file.downcase.match(regex)
  end
  result_set
end

def move_files_to_destination(source_files, destination_dir)
  source_files.map do |each_file|
    source_abs_path = "#{source_dir_abs_path}/#{each_file}"
    destination_abs_path = "#{dest_dir_abs_path}/#{destination_dir}"
    # puts "File: #{each_file} at path #{source_abs_path} will be moved to #{destination_abs_path}"
    puts "File: #{each_file} will be moved to #{destination_abs_path}"
    FileUtils.mv(source_abs_path, destination_abs_path)
    files_moved + 1
  end
rescue StandardError => e
  puts 'Exception: File is probably already moved.'
  puts e
end

def run_logic(directories_list, source_files)
  directories_list.map do |each|
    regex = gen_regex_for_dir_name(each)
    matched_files = get_matching_files(regex, source_files)
    unless matched_files.empty?
      # puts "REGEX: #{r} matched with #{a}"
      move_files_to_destination(matched_files, each)
    end
  end
end

def main
  puts 'Begin execution...'
  root_dir
  arguments_valid?
  source_files = get_files_in_path(source_dir_abs_path)
  # puts "Source files: #{source_files}"
  directories_list = scan_sub_dirs_in_path(destination_dir)
  # puts "Destination Directories: #{directories_list}"
  puts "Found #{directories_list.length} directories in destination path."
  puts 'Generating directory map and moving files...'
  run_logic(directories_list, source_files)
  puts "All done. Moved a total of #{files_moved} files."
end

main
