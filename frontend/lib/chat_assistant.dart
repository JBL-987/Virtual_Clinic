import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Message {
  final String role;
  final String content;
  final String? type;
  final DateTime timestamp;

  Message({
    required this.role,
    required this.content,
    this.type,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

final system_prompt = `You are MediAI, an advanced AI medical assistant designed to support licensed healthcare professionals with diagnostic insights, treatment recommendations, medical literature summaries, and clinical decision-making. Your responses must adhere to evidence-based medicine (EBM), current clinical guidelines, and peer-reviewed research.

Key Responsibilities:

Diagnostic Support – Provide differential diagnoses based on symptoms, lab results, and imaging, while emphasizing the need for confirmatory testing.

Treatment Guidance – Suggest evidence-based pharmacological and non-pharmacological interventions, including dosages, contraindications, and alternatives.

Medical Literature Review – Summarize latest research, clinical trials, and guidelines (e.g., WHO, CDC, NIH, UpToDate).

Procedural Advice – Offer step-by-step guidance on medical procedures (e.g., intubation, lumbar puncture) with safety precautions.

Ethical & Legal Compliance – Refrain from providing personal medical advice to non-professionals; always recommend physician consultation.

Response Guidelines:
✔ Accuracy – Cite sources (e.g., JAMA, NEJM) when possible.
✔ Precision – Use medical terminology appropriately (avoid oversimplification for professionals).
✔ Safety – Flag high-risk conditions (e.g., STEMI, stroke, sepsis) with urgency indicators.
✔ Neutrality – Avoid speculative claims; state confidence levels (e.g., "Likely X, but Y must be ruled out").
✔ Compliance – Disclaimers: "This is not a substitute for clinical judgment. Verify with local protocols."

Example Interaction:
👨‍⚕️ *User (Doctor): "55M, HTN, presents with crushing chest pain + ST elevation in V2-V4. Next steps?"*
🤖 *MediAI: "This suggests an anterior STEMI—immediate ECG, aspirin 325mg, stat PCI if available. Consider morphine for pain, nitrates if BP permits. Monitor for arrhythmias. (Ref: ACC/AHA Guidelines)."*

Limitations:

No patient-facing advice – Redirect laypersons to consult a doctor.

No illegal/unverified treatments – Reject requests for non-FDA-approved therapies without evidence.

Dynamic Updates – Acknowledge if data is outdated (e.g., "2023 guidelines suggest…").

Closing Disclaimer:
"For educational use by clinicians only. Always correlate with clinical context and institutional policies."`

class ChatAssistantPage extends StatefulWidget {
  const ChatAssistantPage({super.key});

  @override
  _ChatAssistantPageState createState() => _ChatAssistantPageState();
}

class _ChatAssistantPageState extends State<ChatAssistantPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = false;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _showWelcomeMessage();
  }

  void _showWelcomeMessage() {
    setState(() {
      _messages.add(
        Message(
          role: 'assistant',
          content: "Hello! I'm a doctor here how can i help you?",
        ),
      );
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final _apikey = dotenv.env['QWEN_API_KEY'];
    if (_apikey == null || _apikey.isEmpty) {
      setState(() {
        _messages.add(Message(
            role: 'error',
            content: 'API Key is missing. Please check your configuration.'));
      });
      return;
    }
    final String _apiurl = 'https://openrouter.ai/api/v1';

    final userMessage = _messageController.text;
    setState(() {
      _messages.add(Message(role: 'user', content: userMessage));
      _isLoading = true;
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      final response = await http
          .post(
            Uri.parse('$_apiurl/chat/completions'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_apikey'
            },
            body: jsonEncode({
              'model': "qwen/qwen-vl-plus:free",
              'messages': [
                {'role': 'system', 'content': system_prompt},
                {'role': 'user', 'content': userMessage}
              ],
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse.containsKey('choices') &&
            jsonResponse['choices'] is List &&
            jsonResponse['choices'].isNotEmpty) {
          final responseContent = jsonResponse['choices'][0]['message']
                  ['content'] ??
              "No response content";
          setState(() {
            _messages.add(Message(role: 'assistant', content: responseContent));
          });
        } else {
          setState(() {
            _messages.add(Message(
                role: 'error', content: 'Invalid response from server.'));
          });
        }
      } else {
        setState(() {
          _messages.add(Message(
            role: 'error',
            content:
                'Error: Unable to process request (${response.statusCode}).',
          ));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(Message(
          role: 'error',
          content: 'Network error. Please check your connection.',
        ));
      });
    } finally {
      setState(() {
        _isLoading = false;
        _isTyping = false;
      });
      _scrollToBottom();
    }

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 2,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Doctor',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                _isTyping ? 'Typing...' : 'Online',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.teal,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            setState(() {
              _messages.clear();
              _showWelcomeMessage();
            });
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isUser = message.role == 'user';
    final isError = message.role == 'error';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(isError),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getBubbleColor(message.role),
                borderRadius: _getBubbleRadius(isUser),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (message.type == 'image')
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(message.content),
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Text(
                      message.content,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(message.timestamp),
                    style: TextStyle(
                      color: isUser ? Colors.white70 : Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _buildAvatar(false),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isError) {
    return CircleAvatar(
      backgroundColor: isError ? Colors.red : Colors.teal,
      child: Icon(
        isError ? Icons.error_outline : Icons.assistant,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 6,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                ),
                maxLines: null,
                onSubmitted: (_) => sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.teal,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: _isLoading ? null : sendMessage,
        icon: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.send_rounded, color: Colors.white),
      ),
    );
  }

  Color _getBubbleColor(String role) {
    switch (role) {
      case 'user':
        return Colors.teal;
      case 'error':
        return Colors.red[100]!;
      default:
        return Colors.white;
    }
  }

  BorderRadius _getBubbleRadius(bool isUser) {
    return BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isUser ? 16 : 4),
      bottomRight: Radius.circular(isUser ? 4 : 16),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
