@description('Location for the Static Web App')
param location string = 'eastus2'

@description('Name of the Static Web App')
param siteName string = 'hi-a11y-demo'

@description('GitHub repository URL')
param repositoryUrl string = 'https://github.com/anabil25/hi-state-services'

@description('GitHub branch')
param branch string = 'main'

resource staticWebApp 'Microsoft.Web/staticSites@2023-12-01' = {
  name: siteName
  location: location
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    repositoryUrl: repositoryUrl
    branch: branch
    buildProperties: {
      appLocation: '_site'
      skipGithubActionWorkflowGeneration: true
    }
  }
}

output staticWebAppName string = staticWebApp.name
output defaultHostname string = staticWebApp.properties.defaultHostname
output deploymentToken string = listSecrets(staticWebApp.id, staticWebApp.apiVersion).properties.apiKey
