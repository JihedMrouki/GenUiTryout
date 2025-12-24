/**
 * Example A2UI Server for Claude Integration
 *
 * This is a minimal example server that bridges the GenUI Flutter app
 * with Claude's API using the A2UI protocol.
 *
 * Setup:
 * 1. npm init -y
 * 2. npm install express cors @anthropic-ai/sdk
 * 3. Set ANTHROPIC_API_KEY environment variable
 * 4. node server.js
 */

const express = require('express');
const Anthropic = require('@anthropic-ai/sdk');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json({ limit: '10mb' }));

const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY || 'your-api-key-here',
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', backend: 'claude-a2ui' });
});

// Main A2UI endpoint
app.post('/generate', async (req, res) => {
  try {
    const { messages, systemInstruction, catalog } = req.body;

    console.log('Received request with', messages?.length || 0, 'messages');

    // Build tools from catalog (GenUI widget definitions)
    const tools = buildToolsFromCatalog(catalog);

    // Call Claude API
    const response = await anthropic.messages.create({
      model: 'claude-3-5-sonnet-20241022',
      max_tokens: 4096,
      system: systemInstruction || 'You are a helpful assistant.',
      messages: convertMessages(messages),
      tools: tools,
    });

    console.log('Claude responded:', response.stop_reason);

    // Convert Claude response to A2UI format
    const a2uiMessages = convertToA2ui(response);

    res.json({
      messages: a2uiMessages,
      status: 'success',
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({
      error: error.message,
      status: 'error',
    });
  }
});

// Convert GenUI messages to Claude format
function convertMessages(messages) {
  if (!messages || !Array.isArray(messages)) {
    return [];
  }

  return messages.map(msg => {
    if (msg.role === 'user') {
      return {
        role: 'user',
        content: msg.content || msg.text || '',
      };
    } else if (msg.role === 'assistant') {
      return {
        role: 'assistant',
        content: msg.content || msg.text || '',
      };
    }
    return null;
  }).filter(Boolean);
}

// Build tool definitions from GenUI catalog
function buildToolsFromCatalog(catalog) {
  if (!catalog || !catalog.items) {
    return [];
  }

  // Convert GenUI catalog items to Claude tool definitions
  return catalog.items.map(item => ({
    name: item.name || 'widget',
    description: item.description || 'Create a Flutter widget',
    input_schema: item.schema || {
      type: 'object',
      properties: {},
    },
  }));
}

// Convert Claude response to A2UI protocol messages
function convertToA2ui(claudeResponse) {
  const a2uiMessages = [];

  // Extract tool calls from Claude response
  if (claudeResponse.content) {
    for (const block of claudeResponse.content) {
      if (block.type === 'tool_use') {
        // This is a widget creation request
        a2uiMessages.push({
          type: 'surfaceUpdate',
          surfaceId: 'main',
          widget: {
            type: block.name,
            properties: block.input,
          },
        });
      } else if (block.type === 'text') {
        // Text response (for debugging or user messages)
        console.log('Claude text:', block.text);
      }
    }
  }

  // If no tool calls, create a default response
  if (a2uiMessages.length === 0) {
    a2uiMessages.push({
      type: 'beginRendering',
      surfaceId: 'main',
      widget: {
        type: 'Text',
        properties: {
          data: 'Received response from Claude',
        },
      },
    });
  }

  return a2uiMessages;
}

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`A2UI Server running on http://localhost:${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
  console.log(`\nMake sure to set ANTHROPIC_API_KEY environment variable!`);
});
