import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQPage extends StatelessWidget {
  final List<FAQ> faqs = [
    FAQ(
      question: 'How do I reserve a parking spot?',
      answer:
          'To reserve a parking spot, open the app, choose a location, select an available spot, and confirm your reservation.',
    ),
    FAQ(
      question: 'What payment methods are accepted?',
      answer:
          'We accept all major credit cards, debit cards, and mobile payment options such as Google Pay and Apple Pay.',
    ),
    FAQ(
      question: 'Can I cancel my reservation?',
      answer:
          'Yes, you can cancel your reservation up to 30 minutes before the reserved time without any charges.',
    ),
    // Add more FAQs as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FAQs',
          style: GoogleFonts.lato(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            return FAQTile(faq: faqs[index]);
          },
        ),
      ),
    );
  }
}

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}

class FAQTile extends StatefulWidget {
  final FAQ faq;

  FAQTile({required this.faq});

  @override
  _FAQTileState createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        leading: Icon(Icons.question_answer),
        title: Text(
          widget.faq.question,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(
          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.faq.answer,
              style: GoogleFonts.lato(),
            ),
          ),
        ],
        onExpansionChanged: (bool expanding) =>
            setState(() => isExpanded = expanding),
      ),
    );
  }
}
