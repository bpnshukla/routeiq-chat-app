import { DefaultAzureCredential } from '@azure/identity';

export class AzureAIService {
  private agentId: string = '';
  private endpoint: string = '';
  private credential: DefaultAzureCredential | null = null;
  private initialized: boolean = false;

  private initialize() {
    if (this.initialized) return;
    
    this.agentId = process.env.AZURE_EXISTING_AGENT_ID || '';
    this.endpoint = process.env.AZURE_EXISTING_AIPROJECT_ENDPOINT || '';
    
    if (!this.agentId || !this.endpoint) {
      console.warn('Azure AI configuration missing. Please check environment variables.');
      console.warn(`  AZURE_EXISTING_AGENT_ID: ${this.agentId || 'MISSING'}`);
      console.warn(`  AZURE_EXISTING_AIPROJECT_ENDPOINT: ${this.endpoint || 'MISSING'}`);
    } else {
      this.credential = new DefaultAzureCredential();
      console.log('Azure AI Service initialized successfully');
      console.log(`  Agent ID: ${this.agentId}`);
      console.log(`  Endpoint: ${this.endpoint}`);
    }
    
    this.initialized = true;
  }

  async sendMessage(message: string, conversationHistory: any[] = []): Promise<string> {
    // Initialize on first use to ensure env vars are loaded
    this.initialize();
    
    if (!this.agentId || !this.endpoint || !this.credential) {
      throw new Error('Azure AI client not initialized. Please check your environment variables.');
    }

    try {
      // Get access token
      const tokenResponse = await this.credential!.getToken(['https://cognitiveservices.azure.com/.default']);
      const accessToken = tokenResponse.token;

      // Build messages array with history
      const messages = [
        ...conversationHistory.map((msg: any) => ({
          role: msg.role || 'user',
          content: msg.content || msg.message,
        })),
        {
          role: 'user',
          content: message,
        },
      ];

      // Invoke agent via REST API
      // Try multiple endpoint formats for Azure AI Foundry
      const baseUrl = this.endpoint.replace('/api/projects/proj-default', '');
      
      // Format 1: Direct agent invoke endpoint
      let agentEndpoint = `${baseUrl}/api/projects/proj-default/agents/${this.agentId}/invoke`;
      
      // Alternative format if the above doesn't work
      // agentEndpoint = `${baseUrl}/agents/${this.agentId}/invoke`;
      
      const response = await fetch(agentEndpoint, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${accessToken}`,
          'api-version': '2024-05-01-preview',
        },
        body: JSON.stringify({
          messages: messages,
          temperature: 0.7,
          max_tokens: 2000,
        }),
      });

      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`Azure AI API error: ${response.status} ${response.statusText} - ${errorText}`);
      }

      const data: any = await response.json();
      
      // Handle different response formats
      if (data.choices && data.choices[0]?.message?.content) {
        return data.choices[0].message.content;
      } else if (data.content) {
        return data.content;
      } else if (data.message) {
        return data.message;
      } else if (typeof data === 'string') {
        return data;
      } else {
        return JSON.stringify(data, null, 2);
      }
    } catch (error: any) {
      console.error('Azure AI API error:', error);
      throw new Error(`Failed to get response from Azure AI: ${error.message}`);
    }
  }
}

