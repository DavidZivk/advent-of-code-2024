def defragment_disk
  input = File.read('day9-input.txt').strip

  disk = []
  input.chars.each_with_index do |ch, idx|
    if idx.even?
      disk.append([idx / 2, ch.to_i])
    else
      disk.append([0, ch.to_i])
    end
  end

  left = 1

  while left < disk.length
    if disk[left][0] != 0
      left += 1
      next
    end

    right = disk.length - 1

    right -= 1 while (disk[right][1] > disk[left][1] || (disk[right][0]).zero?) && right > left

    if right <= left
      left += 1
      next
    end

    space_left = disk[left][1] - disk[right][1]

    disk[left][0] = disk[right][0]
    disk[left][1] = disk[right][1]
    disk[right][0] = 0

    disk.insert(left + 1, [0, space_left]) if space_left.positive?

    left += 1
  end

  disk
end

def get_checksum
  ddisk = defragment_disk

  disk = ddisk - [[0, 0]]

  pos = 0
  checksum = 0

  disk.each do |block|
    block[1].times do
      checksum += pos * block[0]
      pos += 1
    end
  end

  checksum
end

puts get_checksum
