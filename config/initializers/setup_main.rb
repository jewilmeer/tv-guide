Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development? || Rails.env.test?
