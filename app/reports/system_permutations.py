import itertools

def build_system_permutations(data):
    combination_counts = {}
    category_totals = {}
    for system_group in data:
        category_totals.setdefault(system_group['category'], 0) 
        category_totals[system_group['category']] = category_totals[system_group['category']] + system_group['cnt']

    for system_group in data:
        systems = system_group['systems'].split(',')
        category = system_group['category']

        for i in range(1, len(systems)+1):
            combinations = [list(x) for x in itertools.combinations(systems, i)]
            for combination in combinations:
                total = 0
                total_text = 0

                #add counts from source system combinations with any of the systems from this combination
                for overlapping_system_group in data:
                    if overlapping_system_group['category'] != category:
                        continue
                    overlapping_systems = overlapping_system_group['systems'].split(',')
                    if (set(combination) & set(overlapping_systems)):
                        total += int(overlapping_system_group['cnt'])
                        total_text += int(overlapping_system_group['cnt_text'])
                    
                if len(combination) > 1:
                    #only include combinations where the combination total is greater than any single element in it
                    maxCount = max([combination_counts[category + ":" + x]['count'] for x in combination])
                    if maxCount >= total: 
                        total = 0
                        total_text = 0

                    #only include combinations where the total of the full set is larger than any subset (e.g., a,b > a,b,c)
                    for v in combination_counts.values():
                        if v['category'] == category and v['systems'] in ', '.join(combination) and v['count'] >= total:
                            total = 0
                            total_text = 0

                #only add combinations greater than zero
                if total > 0:
                    joined_combination = category + ":" + ','.join(combination)
                    if joined_combination not in combination_counts:
                        combination_counts[joined_combination] = {
                            'category': category,
                            'systems': ', '.join(combination),
                            # 'count': total, '%': round((total/system_group['cnt_total'])*100, 2), 
                            'count': total, '%': round((total/category_totals[category])*100, 2), 
                            'count text': total_text, '% with text': round((total_text/total)*100, 2)
                        }

    return sorted(combination_counts.values(), key=lambda k: (k['category'], -k['count']))
