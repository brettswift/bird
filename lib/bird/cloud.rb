require UserConfig

module Bird
  class Cloud

    def config
      @uconf ||= UserConfig.new(".bird")
      @uconf["bird.yaml"]
    end
  end
end

