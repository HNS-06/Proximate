import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../widgets/team_card.dart';
import '../widgets/skill_chip.dart';
import '../core/services/team_service.dart';
import '../core/utils/skill_matcher.dart';
import '../core/utils/sound_manager.dart';
import '../models/team_model.dart';
import '../models/user_model.dart';

class TeamFormationScreen extends StatefulWidget {
  const TeamFormationScreen({super.key});

  @override
  _TeamFormationScreenState createState() => _TeamFormationScreenState();
}

class _TeamFormationScreenState extends State<TeamFormationScreen> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamDescController = TextEditingController();
  final TextEditingController _projectIdeaController = TextEditingController();
  final List<String> _selectedSkills = [];
  int _teamSize = 4;
  bool _isCreatingTeam = false;

  @override
  Widget build(BuildContext context) {
    final teamService = Provider.of<TeamService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TEAM FORMATION',
          style: TextStyle(
            fontFamily: 'Monospace',
            color: Colors.green,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.green),
            onPressed: () => _showCreateTeamDialog(context),
            tooltip: 'Create Team',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats
            Row(
              children: [
                _buildStatCard('TEAMS', '${teamService.teams.length}'),
                const SizedBox(width: 10),
                _buildStatCard('MEMBERS', '24'),
                const SizedBox(width: 10),
                _buildStatCard('MATCH %', '87'),
              ],
            ),
            const SizedBox(height: 20),
            
            // Team List Header
            const Text(
              'Available Teams:',
              style: TextStyle(
                fontFamily: 'Monospace',
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            
            // Team List
            Expanded(
              child: teamService.teams.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.group_off,
                            color: Colors.green.withOpacity(0.5),
                            size: 60,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'No teams found',
                            style: TextStyle(
                              fontFamily: 'Monospace',
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => _showCreateTeamDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              side: const BorderSide(color: Colors.green),
                            ),
                            child: const Text(
                              'Create First Team',
                              style: TextStyle(
                                fontFamily: 'Monospace',
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: teamService.teams.length,
                      itemBuilder: (context, index) {
                        final team = teamService.teams[index];
                        return TeamCard(
                          team: team,
                          onJoin: () => team.id != null ? _joinTeam(team.id!) : null,
                          onView: () => _viewTeamDetails(team),
                        );
                      },
                    ),
            ),
            
            // Current Team
            if (teamService.currentTeam != null)
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.group, color: Colors.blue),
                        const SizedBox(width: 10),
                        Text(
                          'Your Team: ${teamService.currentTeam!.name}',
                          style: const TextStyle(
                            fontFamily: 'Monospace',
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      teamService.currentTeam!.description ?? 'No description provided',
                      style: TextStyle(
                        fontFamily: 'Monospace',
                        color: Colors.blue.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            '${teamService.currentTeam!.members.length}/${teamService.currentTeam!.maxSize}',
                            style: const TextStyle(
                              fontFamily: 'Monospace',
                              color: Colors.blue,
                            ),
                          ),
                          backgroundColor: Colors.black,
                          side: const BorderSide(color: Colors.blue),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () => teamService.currentTeam!.id != null ? _leaveTeam(teamService.currentTeam!.id!) : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text(
                            'Leave Team',
                            style: TextStyle(
                              fontFamily: 'Monospace',
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      
      // Find Teammates FAB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _findTeammates(),
        icon: const Icon(Icons.search, color: Colors.green),
        label: const Text(
          'Find Teammates',
          style: TextStyle(
            fontFamily: 'Monospace',
            color: Colors.green,
          ),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Monospace',
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Monospace',
                color: Colors.green.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateTeamDialog(BuildContext context) {
    final teamService = Provider.of<TeamService>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Create New Team',
            style: TextStyle(
              fontFamily: 'Monospace',
              color: Colors.green,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _teamNameController,
                  style: const TextStyle(
                    fontFamily: 'Monospace',
                    color: Colors.green,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Team Name',
                    labelStyle: TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _teamDescController,
                  style: const TextStyle(
                    fontFamily: 'Monospace',
                    color: Colors.green,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _projectIdeaController,
                  style: const TextStyle(
                    fontFamily: 'Monospace',
                    color: Colors.green,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Project Idea (Optional)',
                    labelStyle: TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Skills Needed:',
                      style: TextStyle(
                        fontFamily: 'Monospace',
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Flutter',
                        'Backend',
                        'UI/UX',
                        'AI/ML',
                        'Database',
                        'DevOps',
                      ].map((skill) {
                        final isSelected = _selectedSkills.contains(skill);
                        return SkillChip(
                          skill: skill,
                          selected: isSelected,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedSkills.remove(skill);
                              } else {
                                _selectedSkills.add(skill);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Team Size:',
                      style: TextStyle(
                        fontFamily: 'Monospace',
                        color: Colors.green,
                      ),
                    ),
                    Slider(
                      value: _teamSize.toDouble(),
                      min: 2,
                      max: 8,
                      divisions: 6,
                      label: '$_teamSize members',
                      activeColor: Colors.green,
                      inactiveColor: Colors.green.withOpacity(0.3),
                      onChanged: (value) {
                        setState(() {
                          _teamSize = value.round();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Monospace',
                  color: Colors.red,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _isCreatingTeam ? null : () async {
                setState(() => _isCreatingTeam = true);
                await _createTeam(teamService);
                setState(() => _isCreatingTeam = false);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                side: const BorderSide(color: Colors.green),
              ),
              child: _isCreatingTeam
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.green,
                      ),
                    )
                  : const Text(
                      'Create Team',
                      style: TextStyle(
                        fontFamily: 'Monospace',
                        color: Colors.green,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createTeam(TeamService teamService) async {
    if (_teamNameController.text.isEmpty || _teamDescController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await teamService.createTeam(
        name: _teamNameController.text,
        description: _teamDescController.text,
        leaderId: 'current_user',
        maxSize: _teamSize,
        projectIdea: _projectIdeaController.text.isNotEmpty
            ? _projectIdeaController.text
            : null,
        skillsNeeded: _selectedSkills,
      );
      
      SoundManager.playMatch();
      Get.snackbar(
        'Success',
        'Team created successfully!',
        backgroundColor: Colors.black,
        colorText: Colors.green,
      );
      
      // Reset fields
      _teamNameController.clear();
      _teamDescController.clear();
      _projectIdeaController.clear();
      _selectedSkills.clear();
      _teamSize = 4;
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create team: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _joinTeam(String teamId) async {
    final teamService = Provider.of<TeamService>(context, listen: false);
    
    try {
      final success = await teamService.joinTeam(teamId, 'current_user');
      if (success) {
        SoundManager.playConnect();
        Get.snackbar(
          'Success',
          'Joined team successfully!',
          backgroundColor: Colors.black,
          colorText: Colors.green,
        );
      } else {
        Get.snackbar(
          'Error',
          'Team is full or you are already a member',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to join team: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _leaveTeam(String teamId) async {
    final teamService = Provider.of<TeamService>(context, listen: false);
    
    final confirmed = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          'Leave Team?',
          style: TextStyle(
            fontFamily: 'Monospace',
            color: Colors.red,
          ),
        ),
        content: const Text(
          'Are you sure you want to leave this team?',
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
              side: const BorderSide(color: Colors.red),
            ),
            child: const Text(
              'Leave',
              style: TextStyle(
                fontFamily: 'Monospace',
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      try {
        await teamService.leaveTeam(teamId, 'current_user');
        SoundManager.playNotification();
        Get.snackbar(
          'Success',
          'Left team successfully',
          backgroundColor: Colors.black,
          colorText: Colors.green,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to leave team: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  void _viewTeamDetails(Team team) {
    final analysis = SkillMatcher.analyzeTeamCompatibility([
      ['Flutter', 'Dart'],
      ['Backend', 'Database'],
      ['UI/UX', 'Design'],
    ]);
    
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
              team.name,
              style: const TextStyle(
                fontFamily: 'Monospace',
                color: Colors.green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              team.description ?? 'No description available',
              style: TextStyle(
                fontFamily: 'Monospace',
                color: Colors.green.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 20),
            
            // Team Stats
            Row(
              children: [
                _buildTeamStat('Members', '${team.members.length}/${team.maxSize}'),
                const SizedBox(width: 10),
                _buildTeamStat('Match %', '${analysis['score']}%'),
                const SizedBox(width: 10),
                _buildTeamStat('Open Spots', '${team.availableSpots}'),
              ],
            ),
            const SizedBox(height: 20),
            
            // Skills Needed
            const Text(
              'Skills Needed:',
              style: TextStyle(
                fontFamily: 'Monospace',
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: team.skillsNeeded.map((skill) {
                return Chip(
                  label: Text(
                    skill,
                    style: const TextStyle(
                      fontFamily: 'Monospace',
                      color: Colors.green,
                    ),
                  ),
                  backgroundColor: Colors.black,
                  side: const BorderSide(color: Colors.green),
                );
              }).toList(),
            ),
            
            // Project Idea
            if (team.projectIdea != null) ...[
              const SizedBox(height: 20),
              const Text(
                'Project Idea:',
                style: TextStyle(
                  fontFamily: 'Monospace',
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                team.projectIdea!,
                style: TextStyle(
                  fontFamily: 'Monospace',
                  color: Colors.green.withOpacity(0.8),
                ),
              ),
            ],
            
            const Spacer(),
            
            // Action Buttons
            if (team.lookingForMembers && !team.members.contains('current_user'))
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => team.id != null ? _joinTeam(team.id!) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    side: const BorderSide(color: Colors.green),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Join Team',
                    style: TextStyle(
                      fontFamily: 'Monospace',
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamStat(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Monospace',
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Monospace',
                color: Colors.green.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _findTeammates() async {
    final teamService = Provider.of<TeamService>(context, listen: false);
    
    // Show loading
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(color: Colors.green),
      ),
    );
    
    await Future.delayed(const Duration(seconds: 2));
    Get.back();
    
    final teammates = teamService.findTeammates(
      requiredSkills: ['Flutter', 'Firebase', 'UI/UX'],
      maxDistance: 50,
    );
    
    Get.to(
      () => Scaffold(
        appBar: AppBar(
          title: const Text(
            'SUGGESTED TEAMMATES',
            style: TextStyle(
              fontFamily: 'Monospace',
              color: Colors.green,
            ),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: teammates.length,
          itemBuilder: (context, index) {
            final teammate = teammates[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    child: Text(
                      teammate.name[0],
                      style: const TextStyle(
                        color: Colors.blue,
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
                          teammate.name,
                          style: const TextStyle(
                            fontFamily: 'Monospace',
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          teammate.bio,
                          style: TextStyle(
                            fontFamily: 'Monospace',
                            color: Colors.blue.withOpacity(0.8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: teammate.skills.take(3).map((skill) {
                            return Chip(
                              label: Text(
                                skill,
                                style: const TextStyle(
                                  fontFamily: 'Monospace',
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor: Colors.black,
                              side: const BorderSide(color: Colors.blue),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _sendTeamInvite(teammate),
                    icon: const Icon(Icons.group_add, color: Colors.blue),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _sendTeamInvite(UserProfile teammate) async {
    final teamService = Provider.of<TeamService>(context, listen: false);
    
    if (teamService.currentTeam == null) {
      Get.snackbar(
        'Error',
        'You need to create or join a team first',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    try {
      final currentTeamId = teamService.currentTeam?.id;
      if (currentTeamId == null) {
        Get.snackbar(
          'Invite Failed',
          'Unable to send invite: missing team id',
          backgroundColor: Colors.black,
          colorText: Colors.red,
        );
        return;
      }

      await teamService.sendInvite(
        teamId: currentTeamId,
        userId: teammate.id,
        invitedById: 'current_user',
      );
      
      SoundManager.playNotification();
      Get.snackbar(
        'Invite Sent',
        'Team invite sent to ${teammate.name}',
        backgroundColor: Colors.black,
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send invite: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _teamDescController.dispose();
    _projectIdeaController.dispose();
    super.dispose();
  }
}