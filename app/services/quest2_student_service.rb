class Quest2StudentService
  class << self
    # @return [String]
    def all_agents
      Agent.order(:codename).pluck(:codename).join("\n")
    end

    # @return [String]
    def all_missions
      Mission.order(:title).pluck(:title).join("\n")
    end

    # @return [String]
    def agents_with_missions
      Agent.joins(:missions).distinct.order(:codename).includes(:missions).map do |agent|
        mission_titles = agent.missions.order(:title).pluck(:title).join(", ")
        "#{agent.codename}: #{mission_titles}"
      end.join("\n")
    end

    # @return [String]
    def agents_with_missions_sorted_by_mission_count
      agents = Agent.joins(:missions).distinct.includes(:missions)

      sorted_agents = agents.sort_by { |a| [-a.missions.size, a.codename] }

      sorted_agents.map do |agent|
        count = agent.missions.size
        titles = agent.missions.order(:title).pluck(:title).join(', ')
        "#{agent.codename} (#{count}): #{titles}"
      end.join("\n")
    end

    # @return [String]
    def agents_with_skills
      agents = Agent.joins(:skills).includes(:skills).map do |agent|
        skills = agent.skills.order(:name).pluck(:name).join(", ")
        "#{agent.codename}: #{skills}"
      end.join("\n")
    end

    # @return [String]
    def skills_by_agent_count
      skills = Skill.joins(:agents).distinct.includes(:agents)

      sorted_skills = skills.sort_by { |s| [-s.agents.size, s.name] }

      sorted_skills.map do |skill|
        count = skill.agents.size
        agent_names = skill.agents.order(:codename).pluck(:codename).join(', ')

        "#{skill.name} (#{count}): #{agent_names}"
      end.join("\n")
    end
  end
end
