Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'Zmi2YRTiPjLKf8SiMViS5w', 'nG2Z9BnbxmalgTyoRhvnHIqaapjZ52J8XOC7vrr36zA'
  provider :facebook, '154334824603268', '47be4747483dc88821bcfe6a0e6ea6d6' if Rails.env.development?
  provider :facebook, '117884434913747', '3dfbad4725299f687198a5e77d29452f' if Rails.env.production?
  provider :linked_in, 'dtjAOZlJZLHHCiPlBYtgRix2XXBum9fEDrXBZg_XlOVqqIZXA38cmHpLFSd0rakK', 'G96wpyIGOMILPxtLBLG-9Y-FiIEnr0bYbI2vp8pLn7cLNizwiNCEVMaX22j-z8JE'
end
AUTH_PROVIDERS = %w(twitter facebook linked_in)