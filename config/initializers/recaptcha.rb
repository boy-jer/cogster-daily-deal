Recaptcha.configure do |config|
  if Rails.env == "production"
    config.public_key = '6LfYJMQSAAAAANXYlKs7iBcY5ey5wGaFo8maHHm2'
    config.private_key = '6LfYJMQSAAAAAKfl-Gd_uW4zMJfkQtU3FEJDc-z9'
    #below are for littleredbrick.com
    #config.public_key = '6LcEVwsAAAAAAAvRcX2q4lCOmemLlhJg_Zy3WdjJ'
    #config.private_key = '6LcEVwsAAAAAAD6Jo469U0fDrIqAsqbe8JTm3Yk4'
  else
    config.public_key = '6Lcl58ISAAAAALMuyEJo0_MrlJ-Rhu6lHXzN2ErQ'
    config.private_key = '6Lcl58ISAAAAAMLAl-s_tdEzvcyeKmRn9VErf0LQ'
  end
end
