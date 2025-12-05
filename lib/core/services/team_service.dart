import 'package:flutter/material.dart';
import '../../models/team_model.dart';
import '../../models/user_model.dart';

class TeamService extends ChangeNotifier {
  List<Team> _teams = [];
  List<TeamInvite> _pendingInvites = [];
  Team? _currentTeam;
  
  List<Team> get teams => _teams;
  List<TeamInvite> get pendingInvites => _pendingInvites;
  Team? get currentTeam => _currentTeam;
  
  TeamService() {
    _loadMockTeams();
  }
  
  void _loadMockTeams() {
    _teams = [
      Team(
        id: 'team1',
        name: 'Quantum Coders',
        description: 'Building the next-gen quantum app',
        leaderId: 'leader1',
        members: ['user1', 'user2', 'user3'],
        maxSize: 4,
        skillsNeeded: ['Quantum Computing', 'Python', 'Physics'],
        projectIdea: 'Quantum machine learning platform',
        lookingForMembers: true,
      ),
      Team(
        id: 'team2',
        name: 'Flutter Masters',
        description: 'Creating amazing Flutter apps',
        leaderId: 'leader2',
        members: ['user4', 'user5'],
        maxSize: 5,
        skillsNeeded: ['Flutter', 'Firebase', 'UI/UX'],
        projectIdea: 'AR-based navigation app',
        lookingForMembers: true,
      ),
      Team(
        id: 'team3',
        name: 'AI Innovators',
        description: 'Pushing AI boundaries',
        leaderId: 'leader3',
        members: ['user6', 'user7', 'user8', 'user9'],
        maxSize: 4,
        skillsNeeded: ['Machine Learning', 'TensorFlow', 'Python'],
        projectIdea: 'AI-powered health assistant',
        lookingForMembers: false,
      ),
    ];
  }
  
  Future<Team> createTeam({
    required String name,
    required String description,
    required String leaderId,
    int maxSize = 4,
    String? projectIdea,
    List<String> skillsNeeded = const [],
  }) async {
    final newTeam = Team(
      id: 'team_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      leaderId: leaderId,
      members: [leaderId],
      maxSize: maxSize,
      skillsNeeded: skillsNeeded,
      projectIdea: projectIdea,
      lookingForMembers: true,
    );
    
    _teams.add(newTeam);
    _currentTeam = newTeam;
    notifyListeners();
    return newTeam;
  }
  
  Future<bool> joinTeam(String teamId, String userId) async {
    final team = _teams.firstWhere((t) => t.id == teamId);
    
    if (team.isFull) {
      return false;
    }
    
    if (!team.members.contains(userId)) {
      team.members.add(userId);
      notifyListeners();
      return true;
    }
    
    return false;
  }
  
  Future<void> leaveTeam(String teamId, String userId) async {
    final team = _teams.firstWhere((t) => t.id == teamId);
    team.members.remove(userId);
    
    if (team.members.isEmpty) {
      _teams.remove(team);
      if (_currentTeam?.id == teamId) {
        _currentTeam = null;
      }
    }
    
    notifyListeners();
  }
  
  Future<void> sendInvite({
    required String teamId,
    required String userId,
    required String invitedById,
  }) async {
    final invite = TeamInvite(
      id: 'invite_${DateTime.now().millisecondsSinceEpoch}',
      teamId: teamId,
      userId: userId,
      invitedById: invitedById,
      status: InviteStatus.pending,
      createdAt: DateTime.now(),
      sentAt: DateTime.now(),
    );
    
    _pendingInvites.add(invite);
    notifyListeners();
  }
  
  Future<void> respondToInvite(String inviteId, bool accept) async {
    final inviteIndex = _pendingInvites.indexWhere((i) => i.id == inviteId);
    if (inviteIndex == -1) return;
    
    final originalInvite = _pendingInvites[inviteIndex];
    
    if (accept) {
      // Create new invite with updated status
      _pendingInvites[inviteIndex] = TeamInvite(
        id: originalInvite.id,
        teamId: originalInvite.teamId,
        userId: originalInvite.userId,
        status: InviteStatus.accepted,
        createdAt: originalInvite.createdAt,
        invitedById: originalInvite.invitedById,
        sentAt: originalInvite.sentAt,
      );
      await joinTeam(originalInvite.teamId, originalInvite.userId);
    } else {
      _pendingInvites[inviteIndex] = TeamInvite(
        id: originalInvite.id,
        teamId: originalInvite.teamId,
        userId: originalInvite.userId,
        status: InviteStatus.rejected,
        createdAt: originalInvite.createdAt,
        invitedById: originalInvite.invitedById,
        sentAt: originalInvite.sentAt,
      );
    }
    
    notifyListeners();
  }
  
  List<Team> findTeamsBySkills(List<String> userSkills) {
    return _teams.where((team) {
      if (!team.lookingForMembers) return false;
      
      final neededSkills = team.skillsNeeded;
      return userSkills.any((skill) => neededSkills.contains(skill));
    }).toList();
  }
  
  List<UserProfile> findTeammates({
    required List<String> requiredSkills,
    int maxDistance = 50,
  }) {
    // Mock teammates - in real app, filter by proximity and skills
    return List.generate(5, (index) => UserProfile(
      id: 'teammate_$index',
      name: 'Teammate $index',
      interests: ['Hackathons', 'Coding', 'Innovation'],
      bio: 'Looking for a team to build something amazing!',
      shareContact: true,
      lastSeen: DateTime.now(),
      connections: [],
      skills: requiredSkills,
    ));
  }
  
  void updateTeamProject(String teamId, String projectUpdate) {
    // Mock implementation - in real app would update persisted data
    print('Team project updated: $teamId - $projectUpdate');
    notifyListeners();
  }
}
