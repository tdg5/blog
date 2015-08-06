module JekyllHueman
  module WeightedTagsUtil
    MINIMUM_WEIGHT = 90
    MAXIMUM_WEIGHT = 400

    def weighted_tags_for_posts(posts)
      weighted_tags = weight_tags(posts.flat_map(&:tags))
      shuffle(weighted_tags)
    end

    private

    # Scale values in vector based on provided minimum and maximum.
    def scale(vector, min, max)
      vector_min, vector_max = vector.minmax
      min_max_diff = vector_max - vector_min
      range_diff = max - min
      vector.map do |val|
        initial_scale = (val - vector_min) / min_max_diff
        initial_scale * range_diff + min
      end
    end

    # Shuffle tags in a consistent fashion.
    def shuffle(hash)
      keys = hash.keys
      checksum_map = Hash[keys.map(&Digest::MD5.method(:hexdigest)).zip(keys)]
      randomish = checksum_map.values_at(*checksum_map.keys.sort)
      Hash[randomish.zip(hash.values_at(*randomish))]
    end

    # Count and weight tags.
    def weight_tags(tags)
      tag_counts = Hash.new(0)
      tags.each {|tag| tag_counts[tag] += 1 }
      avg = tag_counts.values.inject(0, :+) / tag_counts.length.to_f
      weights = Hash[tag_counts.map { |tag| [tag[0], tag[1] / avg] }]
      Hash[weights.keys.zip(scale(weights.values, MINIMUM_WEIGHT, MAXIMUM_WEIGHT))]
    end
  end
end
