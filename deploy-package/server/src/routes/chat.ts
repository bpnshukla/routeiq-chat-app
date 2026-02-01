import { Router, Request, Response } from 'express';
import { AzureAIService } from '../services/azureAI.js';

const router = Router();
const azureAIService = new AzureAIService();

router.post('/message', async (req: Request, res: Response) => {
  try {
    const { message, conversationHistory } = req.body;

    if (!message) {
      return res.status(400).json({ error: 'Message is required' });
    }

    const response = await azureAIService.sendMessage(message, conversationHistory || []);
    
    res.json({
      response: response,
      timestamp: new Date().toISOString()
    });
  } catch (error: any) {
    console.error('Chat error:', error);
    res.status(500).json({ 
      error: 'Failed to process message',
      details: error.message 
    });
  }
});

export { router as chatRouter };


