import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'chat_assistant.dart';
import 'dart:io';
import 'login_screen.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Disease> diseases = [
    Disease(
      title: "Alzheimer's Disease",
      description:
          'A progressive neurological disorder causing memory loss and cognitive decline.',
      urgencyLevel: UrgencyLevel.medium,
    ),
    Disease(
      title: 'Anemia',
      description:
          'A condition where the blood lacks enough healthy red blood cells to carry oxygen, leading to fatigue and weakness.',
      urgencyLevel: UrgencyLevel.medium,
    ),
    Disease(
      title: 'Appendicitis',
      description:
          'Inflammation of the appendix that requires immediate medical attention and surgical removal.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Asthma',
      description:
          'A chronic respiratory condition causing airway inflammation, leading to wheezing and breathlessness.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Back Problems',
      description:
          'Issues related to the spine or muscles in the back, often causing pain and stiffness.',
      urgencyLevel: UrgencyLevel.medium,
    ),
    Disease(
      title: 'Breast Cancer',
      description:
          'A type of cancer that develops in breast tissue, commonly detected via mammograms.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Bronchitis',
      description:
          'Inflammation of the bronchial tubes, often leading to coughing and difficulty breathing.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Celiac Disease',
      description:
          'An autoimmune condition triggered by gluten, affecting the small intestine.',
      urgencyLevel: UrgencyLevel.low,
    ),
    Disease(
      title: 'Chickenpox',
      description:
          'A highly contagious viral infection causing an itchy rash and blisters.',
      urgencyLevel: UrgencyLevel.low,
    ),
    Disease(
      title: 'Chronic Kidney Disease (CKD)',
      description:
          'A progressive loss of kidney function over time, leading to waste buildup in the body.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Dengue Fever',
      description:
          'A mosquito-borne viral infection causing high fever, severe headache, body aches, and joint pain.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Dermatitis (Eczema)',
      description:
          'A skin condition causing inflammation, redness, itching, often triggered by allergens or irritants.',
      urgencyLevel: UrgencyLevel.low,
    ),
    Disease(
      title: 'Diabetes',
      description:
          'A chronic condition characterized by high blood sugar levels due to insulin deficiency or resistance.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Epilepsy',
      description:
          'A chronic neurological disorder causing recurrent seizures.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Fever',
      description:
          'An elevated body temperature, often a sign of infection or illness.',
      urgencyLevel: UrgencyLevel.medium,
    ),
    Disease(
      title: 'Flu (Influenza)',
      description:
          'A viral infection affecting the respiratory system, causing fever, body aches, and fatigue.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Gastritis',
      description:
          'Inflammation of the stomach lining, leading to nausea, vomiting, and abdominal pain.',
      urgencyLevel: UrgencyLevel.medium,
    ),
    Disease(
      title: 'Gout',
      description:
          'A form of arthritis caused by excess uric acid in the blood, leading to joint pain.',
      urgencyLevel: UrgencyLevel.low,
    ),
    Disease(
      title: 'Hepatitis A, B, and C',
      description:
          'Inflammation of the liver caused by viral infections, with varying modes of transmission.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'High Cholesterol',
      description:
          'Elevated levels of cholesterol in the blood, increasing the risk of cardiovascular diseases.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'HIV/AIDS',
      description:
          'A viral infection that weakens the immune system, making the body vulnerable to infections.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Hyperthyroidism',
      description:
          'Overactive thyroid gland producing excessive hormones, causing rapid heartbeat and weight loss.',
      urgencyLevel: UrgencyLevel.medium,
    ),
    Disease(
      title: 'Hypothyroidism',
      description:
          'Underactive thyroid gland producing insufficient hormones, leading to fatigue and weight gain.',
      urgencyLevel: UrgencyLevel.low,
    ),
    Disease(
      title: 'Hypertension',
      description:
          'A condition where blood pressure is consistently too high, increasing the risk of heart disease and stroke.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Lung Cancer',
      description:
          'A type of cancer that begins in the lungs, often linked to smoking or environmental toxins.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Malaria',
      description:
          'A mosquito-borne disease caused by a parasite, leading to fever, chills, and severe illness if untreated.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Measles',
      description:
          'A viral infection causing fever, cough, and a red rash, often preventable by vaccination.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Migraine',
      description:
          'A neurological condition causing intense headaches, often accompanied by nausea and sensitivity to light and sound.',
      urgencyLevel: UrgencyLevel.medium,
    ),
    Disease(
      title: 'Osteoarthritis',
      description:
          'A degenerative joint disease causing pain, stiffness, and reduced mobility, commonly in older adults.',
      urgencyLevel: UrgencyLevel.medium,
    ),
    Disease(
      title: 'Parkinson\'s Disease',
      description: 'A chronic movement disorder causing tremors and stiffness.',
      urgencyLevel: UrgencyLevel.medium,
    ),
    Disease(
      title: 'Peptic Ulcer',
      description:
          'A sore in the stomach or duodenal lining, often caused by H. pylori infection or NSAIDs.',
      urgencyLevel: UrgencyLevel.medium,
    ),
    Disease(
      title: 'Pneumonia',
      description:
          'An infection that inflames the air sacs in the lungs, potentially causing severe respiratory issues.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Sinusitis',
      description:
          'Inflammation of the sinuses, causing nasal congestion, pain, and pressure.',
      urgencyLevel: UrgencyLevel.low,
    ),
    Disease(
      title: 'Stroke',
      description:
          'A medical emergency caused by interrupted blood flow to the brain, leading to cell damage.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Tuberculosis (TB)',
      description:
          'A bacterial infection affecting the lungs, causing chronic cough, fever, and weight loss.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Typhoid Fever',
      description:
          'A bacterial infection caused by Salmonella typhi, causing prolonged fever, abdominal pain, and weakness, often from contaminated water.',
      urgencyLevel: UrgencyLevel.high,
    ),
    Disease(
      title: 'Urinary Tract Infection (UTI)',
      description:
          'An infection in any part of the urinary system, causing pain and frequent urination.',
      urgencyLevel: UrgencyLevel.medium,
    ),
  ];

  int _currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _getUrgencyLevel(UrgencyLevel level) {
    switch (level) {
      case UrgencyLevel.low:
        return 1;
      case UrgencyLevel.medium:
        return 2;
      case UrgencyLevel.high:
        return 3;
      default:
        return 0;
    }
  }

  void _ascendingsorting(List<Disease> diseases) {
    int n = diseases.length;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        if (_getUrgencyLevel(diseases[j].urgencyLevel) <
            _getUrgencyLevel(diseases[j + 1].urgencyLevel)) {
          Disease temp = diseases[j];
          diseases[j] = diseases[j + 1];
          diseases[j + 1] = temp;
        }
      }
    }
  }

  void _descendingsorting(List<Disease> diseases) {
    int n = diseases.length;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        if (_getUrgencyLevel(diseases[j].urgencyLevel) >
            _getUrgencyLevel(diseases[j + 1].urgencyLevel)) {
          Disease temp = diseases[j];
          diseases[j] = diseases[j + 1];
          diseases[j + 1] = temp;
        }
      }
    }
  }

  void _handleNavigation(int index) {
    setState(() {
      _currentPageIndex = index;
    });

    switch (index) {
      case 1: //Talk to Ai
        _openChatAssistant();
        break;
      case 2: // Profile
        _showProfileDialog();
        break;
      case 3: //Exit
        _showExitConfirmation();
        break;
      case 4: // Logout
        _showLogoutConfirmation();
        break;
    }
  }

  Future<void> _showProfileDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(title: const Text('Profile'), actions: [
        TextButton(
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ProfilePage(userId: 'user_id_here')),
                ),
            child: const Text('Go to Profile'))
      ]),
    );
  }

  Future<void> _showExitConfirmation() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Exit'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );

    if (shouldExit ?? false) {
      exit(0);
    }
  }

  Future<void> _showLogoutConfirmation() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout ?? false) {
      // Implement logout logic here
    }
  }

  Future<void> _openChatAssistant() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatAssistantPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Most Common Diseases',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_upward, color: Colors.white),
            onPressed: () {
              setState(() {
                _ascendingsorting(diseases);
              });
            },
            tooltip: 'Sort Ascending',
          ),
          IconButton(
            icon: const Icon(Icons.arrow_downward, color: Colors.white),
            onPressed: () {
              setState(() {
                _descendingsorting(diseases);
              });
            },
            tooltip: 'Sort Descending',
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          NavigationBar(
            selectedIndex: _currentPageIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(MdiIcons.home),
                label: 'Home',
                tooltip: 'Home Page',
              ),
              NavigationDestination(
                icon: Icon(MdiIcons.robot),
                label: 'Talk',
                tooltip: 'Talk to Doctor',
              ),
              NavigationDestination(
                icon: Icon(Icons.person),
                label: 'Profile',
                tooltip: 'View Profile',
              ),
              NavigationDestination(
                icon: Icon(Icons.exit_to_app),
                label: 'Exit',
                tooltip: 'Exit App',
              ),
              NavigationDestination(
                icon: Icon(Icons.logout),
                label: 'Logout',
                tooltip: 'Logout',
              ),
            ],
            onDestinationSelected: _handleNavigation,
            backgroundColor: Colors.white,
            elevation: 2,
          ),
          Expanded(
            child: diseases.isEmpty
                ? const EmptyStateWidget()
                : DiseaseListView(diseases: diseases),
          ),
        ],
      ),
    );
  }
}

class Disease {
  final String title;
  final String description;
  final UrgencyLevel urgencyLevel;

  const Disease({
    required this.title,
    required this.description,
    required this.urgencyLevel,
  });
}

enum UrgencyLevel { low, medium, high }

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'If you had one of these tell the doctor immediately',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class DiseaseListView extends StatelessWidget {
  final List<Disease> diseases;

  const DiseaseListView({
    required this.diseases,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: diseases.length,
        itemBuilder: (context, index) {
          final disease = diseases[index];
          return DiseaseCard(disease: disease);
        },
      ),
    );
  }
}

class DiseaseCard extends StatelessWidget {
  final Disease disease;

  const DiseaseCard({
    required this.disease,
    super.key,
  });

  Color _getUrgencyColor() {
    switch (disease.urgencyLevel) {
      case UrgencyLevel.low:
        return Colors.green;
      case UrgencyLevel.medium:
        return Colors.orange;
      case UrgencyLevel.high:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          // Show disease details
          showModalBottomSheet(
            context: context,
            builder: (context) => DiseaseDetailsSheet(disease: disease),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                disease.title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                disease.description,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Urgency: ${disease.urgencyLevel.toString().split('.').last}',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: _getUrgencyColor(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DiseaseDetailsSheet extends StatelessWidget {
  final Disease disease;

  const DiseaseDetailsSheet({required this.disease, super.key});

  Future<void> _openChatAssistant(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatAssistantPage()),
    );
  }

  Color _getUrgencyColor() {
    switch (disease.urgencyLevel) {
      case UrgencyLevel.low:
        return Colors.green;
      case UrgencyLevel.medium:
        return Colors.orange;
      case UrgencyLevel.high:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            disease.title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            disease.description,
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Urgency: ${disease.urgencyLevel.toString().split('.').last}',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: _getUrgencyColor(),
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _openChatAssistant(context);
            },
            child: const Text('Talk to doctor'),
          ),
        ],
      ),
    );
  }
}
