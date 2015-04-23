#!/usr/bin/python

import optparse
import os
import re
import sets

INTERFACE_START_PATTERN = r'@interface\W+\b(\w+)\b'
INTERFACE_START_PATTERN_REGEX = re.compile(INTERFACE_START_PATTERN)
INTERFACE_END = '@end'
PROPERTY_PATTERN = r'@Inject\w*Property.*\b(\w+)\b\W*;'
PROPERTY_PATTERN_REGEX = re.compile(PROPERTY_PATTERN)

class Option:
  def __init__(self, args):
    self.files = sets.Set([])
    self.output = None
    if args.input is not None:
      for i, input in enumerate(args.input):
        file = os.path.normpath(input)
        self.files.add(file)

    if args.folder is not None:
      for i, folder in enumerate(args.folder):
        for root, _, files in os.walk(folder):
          for file in files:
            if file.endswith(".m") or file.endswith(".h"):
              file = os.path.join(root, file)
              self.files.add(file)
    return

class ClassMeta:
  def __init__(self, name):
    self.name = name
    self.header = None
    self.injectable_properties = []
    return

  def process(self, file_name, lines):
    if file_name.endswith(".h") and self.header is None:
      head, tail = os.path.split(file_name)
      self.header = tail
    for line in lines:
      match = PROPERTY_PATTERN_REGEX.match(line)
      if match:
        self.injectable_properties.append(match.group(1))
    return

  def merge(self, meta):
    if self.header is None:
      self.header = meta.header
    for property in meta.injectable_properties:
      if not property in self.injectable_properties:
        self.injectable_properties.append(property)
    return

  def write_to(self, file):
    if not len(self.injectable_properties):
      return
    if self.header is None:
      file.write('\n#error %s has auto generated injectable property, but has no .h file\n' % self.name)
      return
    file.write('\n')
    file.write('@interface %s (__Objection__Autogen__)\n' % self.name)
    file.write('@end\n')
    file.write('@implementation %s (__Objection__Autogen__)\n' % self.name)
    if len(self.injectable_properties):
      required = ','.join(['@"%s"' % p for p in self.injectable_properties])
      file.write('objection_requires(%s)\n' % required)
    file.write('@end\n')
    return

class FileMeta:
  def __init__(self, file_name):
    self.classes = {}

    file = open(file_name, 'r')
    lines = []
    interface = None
    for line in file:
      match = INTERFACE_START_PATTERN_REGEX.match(line)
      if match:
        interface = match.group(1)
        continue
      line_strip = line.strip()
      if line_strip == INTERFACE_END:
        if interface is None:
          continue
        if not interface in self.classes:
          self.classes[interface] = ClassMeta(interface)
        classMeta = self.classes[interface]
        classMeta.process(file_name, lines)

        lines = []
        interface = None
        continue
      if not interface is None:
        lines.append(line_strip)

    file.close()
    return

class Meta:
  def __init__(self, option):
    self.classes = {}
    self.headers = []
    for file in option.files:
      file_meta = FileMeta(file)
      for class_name in file_meta.classes:
        if not class_name in self.classes:
          self.classes[class_name] = ClassMeta(class_name)
        class_meta = self.classes[class_name]
        class_meta.merge(file_meta.classes[class_name])
        if not class_meta.header is None and not class_meta.header in self.headers:
          self.headers.append(class_meta.header)
    return

  def write_to(self, file_name):
    file = open(file_name, 'w')
    file.write('#import "Objection.h"\n\n')
    for header in self.headers:
      file.write('#import "%s"\n' % header)
    file.write('\n')
    for class_name in self.classes:
      self.classes[class_name].write_to(file)
    file.close()
    return

def main():
  parser = optparse.OptionParser(usage='usage: %prog -i file [-i file] -o output')
  parser.add_option('-i', '--input', action = 'append')
  parser.add_option('-f', '--folder', action = 'append')
  parser.add_option('-o', '--output')
  args, unused_args = parser.parse_args()
  option = Option(args)
  meta = Meta(option)
  meta.write_to(args.output)

if __name__ == '__main__':
  main()
