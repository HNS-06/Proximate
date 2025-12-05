import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event_model.dart';
import '../core/services/event_api_service.dart';
import '../core/utils/sound_manager.dart';

class EventBrowserScreen extends StatefulWidget {
  const EventBrowserScreen({super.key});

  @override
  _EventBrowserScreenState createState() => _EventBrowserScreenState();
}

class _EventBrowserScreenState extends State<EventBrowserScreen> {
  final EventApiService _eventService = EventApiService();
  final List<HackathonEvent> _events = [];
  bool _isLoading = true;
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    final events = await _eventService.fetchUpcomingHackathons();
    setState(() {
      _events.clear();
      _events.addAll(events);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HACKATHON EVENTS',
          style: TextStyle(
            fontFamily: 'Monospace',
            color: Colors.green,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.green),
            onPressed: _loadEvents,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.green),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Filter Chips
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFilterChip('All', 'all'),
                        _buildFilterChip('Virtual', 'virtual'),
                        _buildFilterChip('Local', 'local'),
                        _buildFilterChip('Upcoming', 'upcoming'),
                        _buildFilterChip('Flutter', 'flutter'),
                        _buildFilterChip('AI/ML', 'ai'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Events Count
                  Row(
                    children: [
                      const Text(
                        'Available Events: ',
                        style: TextStyle(
                          fontFamily: 'Monospace',
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        '${_events.length}',
                        style: const TextStyle(
                          fontFamily: 'Monospace',
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Events List
                  Expanded(
                    child: ListView.builder(
                      itemCount: _events.length,
                      itemBuilder: (context, index) {
                        final event = _events[index];
                        return _buildEventCard(event);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filter == value;
    
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontFamily: 'Monospace',
            color: isSelected ? Colors.black : Colors.green,
          ),
        ),
        selected: isSelected,
        backgroundColor: Colors.black,
        selectedColor: Colors.green,
        checkmarkColor: Colors.black,
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.green.withOpacity(0.5),
        ),
        onSelected: (selected) {
          setState(() => _filter = value);
          SoundManager.play('notification.wav');
        },
      ),
    );
  }

  Widget _buildEventCard(HackathonEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _viewEventDetails(event),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.name,
                        style: const TextStyle(
                          fontFamily: 'Monospace',
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (event.isVirtual)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Text(
                          'VIRTUAL',
                          style: TextStyle(
                            fontFamily: 'Monospace',
                            color: Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  event.description,
                  style: TextStyle(
                    fontFamily: 'Monospace',
                    color: Colors.green.withOpacity(0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.green.withOpacity(0.7),
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      event.location,
                      style: TextStyle(
                        fontFamily: 'Monospace',
                        color: Colors.green.withOpacity(0.7),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.people,
                      color: Colors.green.withOpacity(0.7),
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${event.participants}+',
                      style: TextStyle(
                        fontFamily: 'Monospace',
                        color: Colors.green.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.green.withOpacity(0.7),
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${event.daysUntilStart} days',
                      style: TextStyle(
                        fontFamily: 'Monospace',
                        color: Colors.green.withOpacity(0.7),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => _registerForEvent(event.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        side: const BorderSide(color: Colors.green),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontFamily: 'Monospace',
                          color: Colors.green,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: event.tags.take(3).map((tag) {
                    return Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(
                          fontFamily: 'Monospace',
                          color: Colors.green,
                          fontSize: 10,
                        ),
                      ),
                      backgroundColor: Colors.black,
                      side: const BorderSide(color: Colors.green),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _viewEventDetails(HackathonEvent event) async {
    SoundManager.play('notification.wav');
    
    final details = await _eventService.getEventDetails(event.id);
    final participants = await _eventService.getEventParticipants(event.id);
    
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      event.name,
                      style: const TextStyle(
                        fontFamily: 'Monospace',
                        color: Colors.green,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      event.description,
                      style: TextStyle(
                        fontFamily: 'Monospace',
                        color: Colors.green.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              
              TabBar(
                tabs: const [
                  Tab(text: 'Details'),
                  Tab(text: 'Schedule'),
                  Tab(text: 'Participants'),
                ],
                indicatorColor: Colors.green,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.green.withOpacity(0.5),
                labelStyle: const TextStyle(fontFamily: 'Monospace'),
              ),
              
              Expanded(
                child: TabBarView(
                  children: [
                    // Details Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailItem('Location', event.location),
                          _buildDetailItem('Website', event.website ?? 'Not available'),
                          _buildDetailItem('Date', 
                            '${event.startDate.day}/${event.startDate.month}/${event.startDate.year} - '
                            '${event.endDate.day}/${event.endDate.month}/${event.endDate.year}'
                          ),
                          _buildDetailItem('Participants', '${event.participants}+'),
                          
                          const SizedBox(height: 20),
                          const Text(
                            'Prizes:',
                            style: TextStyle(
                              fontFamily: 'Monospace',
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...(details['prizes'] as List).map((prize) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.green),
                                    ),
                                    child: Center(
                                      child: Text(
                                        prize['place'][0],
                                        style: const TextStyle(
                                          fontFamily: 'Monospace',
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${prize['place']} Place',
                                          style: const TextStyle(
                                            fontFamily: 'Monospace',
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          prize['prize'],
                                          style: TextStyle(
                                            fontFamily: 'Monospace',
                                            color: Colors.green.withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    
                    // Schedule Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: (details['schedule'] as List).map((item) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    border: Border.all(color: Colors.green),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      item['time'],
                                      style: const TextStyle(
                                        fontFamily: 'Monospace',
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['event'],
                                        style: const TextStyle(
                                          fontFamily: 'Monospace',
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (item['speaker'] != null)
                                        Text(
                                          'by ${item['speaker']}',
                                          style: TextStyle(
                                            fontFamily: 'Monospace',
                                            color: Colors.green.withOpacity(0.8),
                                            fontSize: 12,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    
                    // Participants Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: participants.map((participant) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.green.withOpacity(0.2),
                                  child: Text(
                                    participant['name'][0],
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        participant['name'],
                                        style: const TextStyle(
                                          fontFamily: 'Monospace',
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Wrap(
                                        spacing: 5,
                                        runSpacing: 5,
                                        children: (participant['skills'] as List).take(2).map((skill) {
                                          return Chip(
                                            label: Text(
                                              skill,
                                              style: const TextStyle(
                                                fontFamily: 'Monospace',
                                                color: Colors.green,
                                                fontSize: 10,
                                              ),
                                            ),
                                            backgroundColor: Colors.black,
                                            side: const BorderSide(color: Colors.green),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                if (participant['lookingForTeam'] == true)
                                  IconButton(
                                    onPressed: () => _connectWithParticipant(participant),
                                    icon: const Icon(
                                      Icons.connect_without_contact,
                                      color: Colors.green,
                                    ),
                                    tooltip: 'Connect',
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontFamily: 'Monospace',
              color: Colors.green.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Monospace',
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _registerForEvent(String eventId) async {
    final confirmed = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          'Register for Event?',
          style: TextStyle(
            fontFamily: 'Monospace',
            color: Colors.green,
          ),
        ),
        content: const Text(
          'Do you want to register for this hackathon?',
          style: TextStyle(
            fontFamily: 'Monospace',
            color: Colors.green,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Monospace',
                color: Colors.green,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              side: const BorderSide(color: Colors.green),
            ),
            child: const Text(
              'Register',
              style: TextStyle(
                fontFamily: 'Monospace',
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      final success = await _eventService.registerForEvent(eventId, 'current_user');
      if (success) {
        SoundManager.play('connect.wav');
        Get.snackbar(
          'Success',
          'Registered for event successfully!',
          backgroundColor: Colors.black,
          colorText: Colors.green,
        );
      } else {
        Get.snackbar(
          'Error',
          'Registration failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> _connectWithParticipant(Map<String, dynamic> participant) async {
    SoundManager.play('notification.wav');
    
    Get.snackbar(
      'Connection Request',
      'Request sent to ${participant['name']}',
      backgroundColor: Colors.black,
      colorText: Colors.green,
    );
  }
}